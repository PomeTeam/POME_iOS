//
//  SignUpUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift

protocol SignUpUseCaseInterface {
    func execute(requestValue: SignUpRequestModel) -> Observable<UserModel>
}

final class SignUpUseCase: SignUpUseCaseInterface {

    private let userRepository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(requestValue: SignUpRequestModel) -> Observable<UserModel>{
        return userRepository.signUp(requestValue: requestValue)
    }
}

