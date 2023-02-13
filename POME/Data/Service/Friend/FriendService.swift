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
    
    func generateFriendEmotion(id: Int, emotion: Int, completion: @escaping (NetworkResult<BaseResponseModel<RecordResponseModel>>) -> Void) {
        requestDecoded(FriendRouter.postEmotion(id: id, emotion: emotion), animate: true){ response in
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
    
    func deleteFriend(id: String, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        requestDecoded(FriendRouter.deleteFriend(id: id)){ response in
            completion(response)
        }
    }
    
    func getFriends(pageable: PageableModel, completion: @escaping (NetworkResult<[FriendsResponseModel]>) -> Void) {
        requestDecoded(FriendRouter.getFriends(pageable: pageable), animate: true){
            response in
            completion(response)
        }
    }
    
    func getFriendRecord(id: String, pageable: PageableModel, animate: Bool,completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        requestDecoded(FriendRouter.getFriendRecord(id: id, pageable: pageable), animate: animate){ response in
            completion(response)
        }
    }
    
    func getAllFriendsRecord(pageable: PageableModel, animate: Bool, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        requestDecoded(FriendRouter.getAllFriendsRecord(pageable: pageable), animate: animate){ response in
            completion(response)
        }
    }
}
