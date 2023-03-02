//
//  RenewRequestModel.swift
//  POME
//
//  Created by 박소윤 on 2023/03/02.
//

import Foundation

struct RenewRequestModel: Encodable{
    let userId: String = UserManager.userId ?? ""
    let userNickname: String = UserManager.nickName ?? ""
}
