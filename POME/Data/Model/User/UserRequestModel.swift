//
//  UserRequestModel.swift
//  POME
//
//  Created by gomin on 2023/01/26.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let nickname: String
    let phoneNum: String
    let imageKey: String?
}

struct SignInRequestModel: Encodable {
    let phoneNum: String
}

struct SendSMSRequestModel: Encodable{
    let phoneNum: String
}

struct CheckNicknameRequestModel: Encodable{
    let nickName: String
}
