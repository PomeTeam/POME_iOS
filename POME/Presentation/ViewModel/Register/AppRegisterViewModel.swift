//
//  AppRegisterViewModel.swift
//  POME
//
//  Created by gomin on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa


class AppRegisterViewModel{
    
    private let sendCodeUseCase: SendCodeUseCaseInterface
    private let loginUseCase: LoginUseCaseInterface
    var phoneNumRelay = BehaviorRelay<String?>(value: nil)
    var codeRelay = BehaviorRelay<String?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        let phoneTextField: Observable<String>
        let codeTextField: Observable<String>
        let sendCodeButtonControlEvent: ControlEvent<Void>
        let nextButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let ctaSendCodeButtonActivate: Driver<Bool>
        let ctaButtonActivate: Driver<Bool>
        let user: Observable<UserModel>
        let signUp: BehaviorRelay<Bool>
        let codeMatch: Driver<Bool>
    }
    
    init(sendCodeUseCase: SendCodeUseCaseInterface = SendCodeUseCase(),
         loginUseCase: LoginUseCaseInterface = LoginUseCase()) {
        self.sendCodeUseCase = sendCodeUseCase
        self.loginUseCase = loginUseCase
    }
    
    func transform(input: Input) -> Output{
        
        input.phoneTextField
            .map(Optional.init)
            .bind(to: phoneNumRelay)
        
        input.codeTextField
            .map(Optional.init)
            .bind(to: codeRelay)
        
        // 인증번호 발송 버튼 활성화 유무
        let ctaSendCodeButtonActivate = input.phoneTextField
            .map{ phone in
                self.isValidPhone(phone)
            }.asDriver(onErrorJustReturn: false)
        
        // 인증번호 발송
        let codeAndUserResponse = input.sendCodeButtonControlEvent
            .map { [self] in
                PhoneNumRequestModel(phoneNum: phoneNumRelay.value ?? "")
            }.flatMap {
                self.sendCodeUseCase.execute(requestValue: $0)
            }.share()
        
        // 인증번호 일치 여부 확인
        let authCodeRelay = BehaviorRelay<String?>(value: nil)
        _ = codeAndUserResponse
            .map{ model, isUser in
                model.value
            }.bind(to: authCodeRelay)
        
        // 유저 체크
        let isUser = BehaviorRelay<Bool>(value: false)
        _ = codeAndUserResponse
            .map { model, isUser in
                isUser
            }.bind(to: isUser)
        
        // '동의하고 시작하기' 버튼 활성화 유무
        let ctaButtonActivate = input.codeTextField
            .map{ code in
                !code.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        
        /* '동의하고 시작하기' 버튼 클릭 후
            1. 코드 입력값과 인증번호가 일치하지 않을 때 에러메세지 출력
            2. 코드 입력값과 인증번호가 일치할 때
                2-1. 유저일 때, 로그인 API 호출 후 기록탭 이동
                2-2. 유저가 아닐 때, 회원가입 페이지로 이동
         */
        
        // 2-1
        let loginResponse = input.nextButtonControlEvent
            .filter{isUser.value && authCodeRelay.value == self.codeRelay.value}
            .map{ [self] in
                SignInRequestModel(phoneNum: phoneNumRelay.value ?? "")
            }.flatMap{
                self.loginUseCase.execute(requestValue: $0)
            }.do{
                self.saveUserData($0)
            }.share()
        
        // 2-2
        let signUpRelay = BehaviorRelay<Bool>(value: false)
        _ = input.nextButtonControlEvent
            .filter{authCodeRelay.value == self.codeRelay.value}
            .map{!isUser.value}
            .bind(to: signUpRelay)
        
        // 1
        let codeMatchResponse = input.nextButtonControlEvent
            .map{
                authCodeRelay.value == self.codeRelay.value
            }
            .asDriver(onErrorJustReturn: true)
        
        
        return Output(ctaSendCodeButtonActivate: ctaSendCodeButtonActivate,
                      ctaButtonActivate: ctaButtonActivate,
                      user: loginResponse,
                      signUp: signUpRelay,
                      codeMatch: codeMatchResponse)
    }
    
    // 전화번호 유효성 검사
    func isValidPhone(_ phone: String) -> Bool {
        if phone.isEmpty {return false}
        
        let pattern = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        var isPhoneNumValid = regex?.firstMatch(in: phone, options: [], range: NSRange(location: 0, length: phone.count))
        
        return isPhoneNumValid != nil
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
        // 자동 로그인을 위해 phoneNum과 token을 기기에 저장
        UserDefaults.standard.set(self.phoneNumRelay.value, forKey: UserDefaultKey.phoneNum)
    }
    
}
