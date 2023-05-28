//
//  CheckNicknameUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift

protocol CheckNicknameUseCaseInterface {
    func execute(requestValue: CheckNicknameRequestModel) -> Observable<BaseResponseModel<Bool>>
}

final class CheckNicknameUseCase: CheckNicknameUseCaseInterface {

    private let userRepository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(requestValue: CheckNicknameRequestModel) -> Observable<BaseResponseModel<Bool>>{
        return userRepository.checkNickname(requestValue: requestValue)
    }
}
