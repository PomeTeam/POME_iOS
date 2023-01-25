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
    case postFriend(friendId: Int)
    case deleteFriend(friendId: Int)
    case getFriendSearch(friendId: String, pageable: PageableModel)
    case getFriends(pageable: PageableModel)
    case checkNickname(nickName: String)
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signUp(let nickname, let phoneNum, let imageKey):
            return HTTPMethodURL.POST.signUp
        case .signIn(let phoneNum):
            return HTTPMethodURL.POST.signIn
        case .getFriendSearch(let id):
            return HTTPMethodURL.GET.friendSearch + "/\(id)"
        case .postFriend(let id):
            return HTTPMethodURL.POST.friend + "/\(id)"
        case .deleteFriend(let id):
            return HTTPMethodURL.DELETE.friend + "/\(id)"
        case .getFriends:
            return HTTPMethodURL.GET.friends
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
        case .getFriendSearch:
            return .get
        case .postFriend:
            return .post
        case .deleteFriend:
            return .delete
        case .getFriends:
            return .get
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
        case .getFriendSearch:
            return .requestPlain
        case .postFriend:
            return .requestPlain
        case .deleteFriend:
            return .requestPlain
        case .getFriends(let pageable):
            return .requestParameters(parameters: ["userId": UserManager.userId ?? "",
                                                   "pageable" : pageable], encoding: URLEncoding.queryString)
        case .checkNickname(let nickName):
            return .requestParameters(parameters: ["nickName": nickName], encoding: URLEncoding.queryString)
        }
    }
}
