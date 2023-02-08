//
//  FriendProfileImageManager.swift
//  POME
//
//  Created by 박소윤 on 2023/02/08.
//

import Foundation

class FriendProfileImageManager{
    
    private var friendsImage = [String : String]()
    
    static let shared = FriendProfileImageManager()
    
    private init() {}
    
    func construct(by friends: [FriendsResponseModel]){
        friends.forEach{
            friendsImage[$0.friendNickName] = $0.imageKey
        }
    }
    
    func getProfileImage(nickname: String) -> String{
        friendsImage[nickname] ?? ""
    }
}
