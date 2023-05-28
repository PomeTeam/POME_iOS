//
//  SendCodeUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/27.
//

import Foundation
import RxSwift

protocol SendCodeUseCaseInterface {
    func execute(requestValue: PhoneNumRequestModel) -> Observable<(SendSMSResponseModel, Bool)>
}

final class SendCodeUseCase: SendCodeUseCaseInterface {

    private let userRepository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(requestValue: PhoneNumRequestModel) -> Observable<(SendSMSResponseModel, Bool)>{
        let sendSMSResponseModel = userRepository.sendCode(requestValue: requestValue)
        let isUser = userRepository.checkUser(requestValue: requestValue)
        
        let response = Observable.combineLatest(sendSMSResponseModel, isUser)
        
        return response
    }
}
