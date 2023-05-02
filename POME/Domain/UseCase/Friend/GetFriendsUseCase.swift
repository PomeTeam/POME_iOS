//
//  GetFriendsUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift

protocol GetFriendsUseCaseInterface {
    func execute() -> Observable<[FriendsResponseModel]>
}

final class GetFriendsUseCase: GetFriendsUseCaseInterface {

    private let friendRepository: FriendRepositoryInterface

    init(friendRepository: FriendRepositoryInterface = FriendRepository()) {
        self.friendRepository = friendRepository
    }

    func execute() -> Observable<[FriendsResponseModel]>{
        return friendRepository.getFriends()
    }
}


