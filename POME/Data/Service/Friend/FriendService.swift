//
//  FriendService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

final class FriendService: MultiMoyaService{
    static let shared = FriendService()
    private init() { }
    let provider = MultiMoyaService(plugins: [MoyaLoggerPlugin()])
}

extension FriendService{
    
    func generateFriendEmotion(id: Int, emotion: Int, completion: @escaping (NetworkResult<RecordResponseModel>) -> Void) {
        provider.requestDecoded(FriendRouter.postEmotion(id: id, emotion: emotion), animate: true){ response in
            completion(response)
        }
    }
    
    func getFriendSearch(id: String, completion: @escaping (Result<BaseResponseModel<[FriendsResponseModel]>, Error>) -> Void) {
        provider.requestDecoded(FriendRouter.getFriendSearch(id: id)) { response in
            completion(response)
        }
    }
    
    func generateNewFriend(id: String, completion: @escaping (Result<Int, Error>) -> Void) {
        provider.requestNoResultAPI(FriendRouter.postFriend(id: id)){ response in
            completion(response)
        }
    }
    
    func deleteFriend(id: String, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        provider.requestDecoded(FriendRouter.deleteFriend(id: id)){ response in
            completion(response)
        }
    }
    
    func getFriends(pageable: PageableModel, completion: @escaping (NetworkResult<[FriendsResponseModel]>) -> Void) {
        provider.requestDecoded(FriendRouter.getFriends(pageable: pageable), animate: true){
            response in
            completion(response)
        }
    }
    
    func getFriendRecord(id: String, pageable: PageableModel, animate: Bool,completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        provider.requestDecoded(FriendRouter.getFriendRecord(id: id, pageable: pageable), animate: animate){ response in
            completion(response)
        }
    }
    
    func getAllFriendsRecord(pageable: PageableModel, animate: Bool, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        provider.requestDecoded(FriendRouter.getAllFriendsRecord(pageable: pageable), animate: animate){ response in
            completion(response)
        }
    }
    
    func hideFriendRecord(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.requestNoResultAPI(FriendRouter.deleteFriendRecord(id: id), animate: true){ response in
            completion(response)
        }
    }
}


