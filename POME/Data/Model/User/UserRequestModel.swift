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

// 인증 번호 전송 & 유저 체크 시 사용
struct PhoneNumRequestModel: Encodable{
    let phoneNum: String
}

struct CheckNicknameRequestModel: Encodable{
    let nickName: String
}
