//
//  RegisterReactionUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift

struct RegisterReactionRequestValue{
    let friendId: Int
    let emotionId: Int
}

protocol RegisterReactionUseCaseInterface {
    func execute(requestValue: RegisterReactionRequestValue) -> Observable<RecordResponseModel>
}

final class RegisterReactionUseCase: RegisterReactionUseCaseInterface {

    private let friendRepository: FriendRepositoryInterface

    init(friendRepository: FriendRepositoryInterface = FriendRepository()) {
        self.friendRepository = friendRepository
    }

    func execute(requestValue: RegisterReactionRequestValue) -> Observable<RecordResponseModel>{
        return friendRepository.registerReaction(requestValue: requestValue)
    }
}
