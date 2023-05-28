//
//  LoginUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/27.
//

import Foundation
import RxSwift

protocol LoginUseCaseInterface {
    func execute(requestValue: SignInRequestModel) -> Observable<UserModel>
}

final class LoginUseCase: LoginUseCaseInterface {

    private let userRepository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(requestValue: SignInRequestModel) -> Observable<UserModel>{
        return userRepository.signIn(requestValue: requestValue)
    }
}
