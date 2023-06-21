//
//  OnboardingViewModel.swift
//  POME
//
//  Created by gomin on 2023/06/21.
//

import Foundation
import RxSwift
import RxCocoa

/* Remember-me
    1. 기존에 토큰 값이 존재할 때 -> 로그인 후 기록탭 이동
    2. 토큰 값이 부재할 때 -> 로그인 페이지 이동
 */


final class OnboardingViewModel: BaseViewModel {
    
    private let loginUseCase: LoginUseCaseInterface
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        let ctaButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let rememberMeDriver: Driver<Bool>
        let user: Observable<UserModel>
    }
    
    init(loginUseCase: LoginUseCaseInterface = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
        let token = UserManager.token ?? ""
        let phoneNum = UserManager.phoneNum ?? ""
        
        let isTokenExist = input.ctaButtonControlEvent
            .map { _ in
                !token.isEmpty && !phoneNum.isEmpty
            }.asObservable()
        
        let loginResponse = isTokenExist
            .map { _ in
                SignInRequestModel(phoneNum: phoneNum)
            }.flatMap {
                self.loginUseCase.execute(requestValue: $0)
            }.do{
                self.saveUserData($0)
            }.share()
        
        let rememberMeDriver = isTokenExist.asDriver(onErrorJustReturn: false)
        
        return Output(rememberMeDriver: rememberMeDriver,
                      user: loginResponse)
    }
    
    // 유저 정보 저장
    func saveUserData(_ user: UserModel) {
        let token = user.accessToken ?? ""
        let userId = user.userId ?? ""
        let nickName = user.nickName ?? ""
        let profileImg = user.imageURL ?? ""
        
        UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
        UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
        UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
        UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
    }
    
}
