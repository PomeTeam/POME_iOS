//
//  FriendService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class FriendService: MultiMoyaService{
    static let shared = FriendService()
    private init() { }
}

extension FriendService{
    
    func generateFriendEmotion(id: Int, emotion: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(FriendRouter.postEmotion(id: id, emotion: emotion)){ response in
            completion(response)
        }
    }
    
    func getFriendSearch(id: String, completion: @escaping (Result<BaseResponseModel<[FriendsResponseModel]>, Error>) -> Void) {
        requestDecoded(FriendRouter.getFriendSearch(id: id)) { response in
            completion(response)
        }
    }
    
    func generateNewFriend(id: String, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(FriendRouter.postFriend(id: id)){ response in
            completion(response)
        }
    }
    
    func deleteFriend(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(FriendRouter.deleteFriend(id: id)){ response in
            completion(response)
        }
    }
    
    func getFriends(pageable: PageableModel, completion: @escaping (Result<[FriendsResponseModel], Error>) -> Void) {
        requestDecoded(FriendRouter.getFriends(pageable: pageable)){ response in
            completion(response)
        }
    }
    
    func getFriendRecord(id: String, pageable: PageableModel, completion: @escaping (Result<[RecordResponseModel], Error>) -> Void) {
        requestDecoded(FriendRouter.getFriendRecord(id: id, pageable: pageable)){ response in
            completion(response)
        }
    }
    
    func getAllFriendsRecord(pageable: PageableModel, completion: @escaping (Result<[FriendsResponseModel], Error>) -> Void) {
//        requestDecoded(FriendRouter.getFriendRecord){ response in
//            completion(response)
//        }
    }
}
