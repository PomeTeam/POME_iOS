//
//  UserService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class UserService: MultiMoyaService{
    static let shared = UserService()
    private init() { }
}

extension UserService{
    
    func signUp(nickname: String, phoneNum: String, imageKey: String, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(UserRouter.signUp(nickname: nickname, phoneNum: phoneNum, imageKey: imageKey)){ response in
            completion(response)
        }
    }
    
    func signIn(phoneNum: String, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(UserRouter.signIn(phoneNum: phoneNum)){ response in
            completion(response)
        }
    }
    
    func getFriendSearch(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(FriendRouter.getFriendSearch(id: id)){ response in
            completion(response)
        }
    }
    
    func generateNewFriend(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
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
    
    func checkNickname(nickName: String, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(UserRouter.checkNickname(nickName: nickName)){ response in
            completion(response)
        }
    }
}
