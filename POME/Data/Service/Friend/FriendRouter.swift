//
//  FriendRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum FriendRouter: BaseRouter{
    case postEmotion(id: Int, emotion: Int)
    case getFriendSearch(id: Int)
    case postFriend(id: Int)
    case deleteFriend(id: Int)
    case getFriends(pageable: PageableModel)
    case getFriendRecord(id: String, pageable: PageableModel)
    case getAllFriendsRecord
}

extension FriendRouter{
    
    var path: String {
        switch self {
        case .postEmotion(let id, _):
            return HTTPMethodURL.POST.friendEmotion + "/\(id)" + "friend-emotion"
        case .getFriendSearch(let id):
            return HTTPMethodURL.GET.friendSearch + "/\(id)"
        case .postFriend(let id):
            return HTTPMethodURL.POST.friend + "/\(id)"
        case .deleteFriend(let id):
            return HTTPMethodURL.DELETE.friend + "/\(id)"
        case .getFriends:
            return HTTPMethodURL.GET.friends
        case .getFriendRecord(let id, _):
            return HTTPMethodURL.GET.recordOfFriend + "/\(id)"
        case .getAllFriendsRecord:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postEmotion:
            return .post
        case .getFriendSearch:
            return .get
        case .postFriend:
            return .post
        case .deleteFriend:
            return .delete
        case .getFriends:
            return .get
        case .getFriendRecord:
            return  .get
        case .getAllFriendsRecord:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postEmotion(_, let emotion):
            return .requestParameters(parameters: [:],
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
        case .getFriendRecord(_, let pageable):
            return .requestParameters(parameters: ["page" : pageable.page,
                                                   "size" : pageable.size,
                                                   "sort" : pageable.sort], encoding: URLEncoding.queryString)
        case .getAllFriendsRecord:
            return .requestPlain
            
            /*
            case .renameAlbum(_, let request):
                return .requestParameters(parameters: ["name": request.name],
                                          encoding: JSONEncoding.default)
             */
        }
    }
}
