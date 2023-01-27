//
//  FriendsResponseModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct FriendsResponseModel: Decodable{
    let friendUserId: String
    let friendNickName: String
    let imageKey: String
}
