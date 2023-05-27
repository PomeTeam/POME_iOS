//
//  AppRegisterViewModel.swift
//  POME
//
//  Created by gomin on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa


enum RegisterType {
    case signIn
    case userRegister
}


class AppRegisterViewModel{
    
    private let sendCodeUseCase: SendCodeUseCaseInterface
    private let loginUseCase: LoginUseCaseInterface
    var phoneNumRelay = BehaviorRelay<String?>(value: nil)
    var codeRelay = BehaviorRelay<String?>(value: nil)
    
    struct Input{
        let phoneTextField: Observable<String>
        let codeTextField: Observable<String>
        let sendCodeButtonControlEvent: ControlEvent<Void>
        let nextButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let canSendCode: Driver<Bool>
        let canMoveNext: Driver<Bool>
        let user: Observable<UserModel>
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
        let canSendCode = input.phoneTextField
            .map{ [self] phone in
                isValidPhone(phone)
            }.asDriver(onErrorJustReturn: false)
        
        // 인증번호 발송
        let codeStatus = input.sendCodeButtonControlEvent
            .map { [self] in
                PhoneNumRequestModel(phoneNum: phoneNumRelay.value ?? "")
            }.flatMap {
                self.sendCodeUseCase.execute(requestValue: $0)
            }
        
        // 인증번호 일치 여부 확인
        let errorStatus = codeStatus
            .map { model, isUser in
                self.codeRelay.value != model.value
            }.asDriver(onErrorJustReturn: true)
        
        // 유저 체크
        let isUser = BehaviorRelay<Bool>(value: false)
        let userStatus = codeStatus
            .map { model, isUser in
                isUser ? true : false
            }.bind(to: isUser)
        
        // '동의하고 시작하기' 버튼 활성화 유무
        let canMoveNext = input.codeTextField
            .map{ [self] code in
                !code.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        // '동의하고 시작하기' 버튼 클릭 후
        /*
        TODO: 조건에 따라 이벤트 처리를 다르게 하고 싶은데 모르겠습니다.
        일단 유저일 때(하단 2-1의 경우) 로그인API 호출하는 방식으로 함.
        어떻게 해야하나요?
     
        [원하는 결과물]
            1. 코드 입력값과 인증번호가 일치하지 않을 때 에러메세지 출력
            2. 코드 입력값과 인증번호가 일치할 때
                2-1. 유저일 때, 로그인 API 호출 후 기록탭 이동
                2-2. 유저가 아닐 때, 회원가입 페이지로 이동
         */
        
        let userResponse = input.nextButtonControlEvent
            .filter{isUser.value}
            .map{ [self] in
                SignInRequestModel(phoneNum: phoneNumRelay.value ?? "")
            }.flatMap{
                self.loginUseCase.execute(requestValue: $0)
            }.do{
                // 유저 정보 저장
                let token = $0.accessToken ?? ""
                let userId = $0.userId ?? ""
                let nickName = $0.nickName ?? ""
                let profileImg = $0.imageURL ?? ""
                
                UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
                UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
                UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
                UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
                // 자동 로그인을 위해 phoneNum과 token을 기기에 저장
                UserDefaults.standard.set(self.phoneNumRelay.value, forKey: UserDefaultKey.phoneNum)
            }
        
        
        return Output(canSendCode: canSendCode, canMoveNext: canMoveNext, user: userResponse)
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        if phone.isEmpty {return false}
        
        let pattern = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        var isPhoneNumValid = regex?.firstMatch(in: phone, options: [], range: NSRange(location: 0, length: phone.count))
        
        return isPhoneNumValid != nil
    }
    
}
