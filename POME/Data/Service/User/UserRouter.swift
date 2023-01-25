//
//  UserRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum UserRouter: BaseRouter{
    case signUp(nickname: String, phoneNum: String, imageKey: String)
    case signIn(phoneNum: String)
    case checkNickname(nickName: String)
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signUp(let nickname, let phoneNum, let imageKey):
            return HTTPMethodURL.POST.signUp
        case .signIn(let phoneNum):
            return HTTPMethodURL.POST.signIn
        case .checkNickname(let nickName):
            return HTTPMethodURL.POST.nicknameDuplicate
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .signIn:
            return .post
        case .checkNickname:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let nickname, let phoneNum, let imageKey):
            return .requestParameters(parameters: ["nickname": nickname,
                                                   "phoneNum": phoneNum,
                                                   "imageKey": imageKey],
                                      encoding: JSONEncoding.default)
        case .signIn(let phoneNum):
            return .requestParameters(parameters: ["phoneNum": phoneNum],
                                      encoding: JSONEncoding.default)
        case .checkNickname(let nickName):
            return .requestParameters(parameters: ["nickName": nickName], encoding: URLEncoding.queryString)
        }
    }
}
