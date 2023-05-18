//
//  GetAllFriendsRecordsUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift

protocol GetAllFriendsRecordsUseCaseInterface {
    func execute(requestModel: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>>
}

final class GetAllFriendsRecordsUseCase: GetAllFriendsRecordsUseCaseInterface {

    private let friendRepository: FriendRepositoryInterface

    init(friendRepository: FriendRepositoryInterface = FriendRepository()) {
        self.friendRepository = friendRepository
    }
    
    func execute(requestModel: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>> {
        friendRepository.getAllFriendsRecords(requestModel: requestModel)
    }

}
