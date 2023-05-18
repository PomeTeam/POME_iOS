//
//  FriendRepositoryInterface.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol FriendRepositoryInterface{
    func getFriends() -> Observable<[FriendsResponseModel]>
    func registerReaction(requestValue: RegisterReactionRequestValue) -> Observable<RecordResponseModel>
    func hideFriendRecord(recordId: Int) -> Observable<BaseResponseStatus>
    func getAllFriendsRecords(requestModel: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>>
    func getFriendRecords(requestValue: GetFriendRecordsRequestValue) -> Observable<PageableResponseModel<RecordResponseModel>>
}
