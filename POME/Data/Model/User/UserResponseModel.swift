//
//  UserResponseModel.swift
//  POME
//
//  Created by gomin on 2023/01/26.
//

import Foundation

// SignUp, SignIn 시 공통으로 사용
struct UserModel: Decodable {
    let userId: String?
    let nickName: String?
    let imageURL: String?
    let accessToken: String?
}

struct SendSMSResponseModel: Decodable{
    let value: String
    let message: String?
}

struct PresignedURLResponseModel: Decodable {
    let id: String
    let presignedUrl: String
}

struct checkNickNameResponseModel: Decodable{
    let success: Bool?
    let httpCode: Int?
    let localDateTime: String?
    let httpStatus: String?
    let message: String?
    let data: Bool?
}
