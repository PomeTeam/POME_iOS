//
//  GetFriendRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift

struct GetFriendRecordsRequestValue{
    let friendId: String
    let pageable: PageableModel
}

protocol GetFriendRecordsUseCaseInterface {
    func execute(requestModel: GetFriendRecordsRequestValue) -> Observable<PageableResponseModel<RecordResponseModel>>
}

final class GetFriendRecordsUseCase: GetFriendRecordsUseCaseInterface {

    private let friendRepository: FriendRepositoryInterface

    init(friendRepository: FriendRepositoryInterface = FriendRepository()) {
        self.friendRepository = friendRepository
    }
    
    func execute(requestModel: GetFriendRecordsRequestValue) -> Observable<PageableResponseModel<RecordResponseModel>> {
        friendRepository.getFriendRecords(requestValue: requestModel)
    }

}
