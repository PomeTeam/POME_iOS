//
//  UserRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya
import UIKit

enum UserRouter: BaseRouter{
    case signUp(param: SignUpRequestModel)
    case signIn(param: SignInRequestModel)
    case logout
    case deleteUser(reason: String)
    
    case getMarshmallow
    
    case sendSMS(param: PhoneNumRequestModel)
    case checkNickName(param: CheckNicknameRequestModel)
    case checkUser(param: PhoneNumRequestModel)
    
    case getPresignedURLServer(id: String)
}

extension UserRouter{
    
    var baseURL: URL {
        switch self {
        case .getPresignedURLServer:
            let url = Bundle.main.infoDictionary?["GET_PRESIGNED_URL"] as? String ?? ""
            return URL(string: "http://" + url)!
        default:
            let url = Bundle.main.infoDictionary?["API_URL"] as? String ?? ""
            return URL(string: "http://" + url)!
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return HTTPMethodURL.POST.signUp
        case .signIn:
            return HTTPMethodURL.POST.signIn
        case .sendSMS:
            return HTTPMethodURL.POST.sms
        case .checkNickName:
            return HTTPMethodURL.POST.nicknameDuplicate
        case .checkUser:
            return HTTPMethodURL.POST.checkUser
        case .logout:
            return HTTPMethodURL.POST.logout
        case .deleteUser(let reason):
            return HTTPMethodURL.DELETE.deleteUser + "/\(reason)"
        case .getMarshmallow:
            return HTTPMethodURL.marshmallow
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .signIn:
            return .post
        case .sendSMS:
            return .post
        case .checkNickName:
            return .post
        case .getPresignedURLServer:
            return .get
        case .checkUser:
            return .post
        case .logout:
            return .post
        case .deleteUser:
            return .delete
        case .getMarshmallow:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let param):
            return .requestJSONEncodable(param)
        case .signIn(let param):
            return .requestJSONEncodable(param)
        case .sendSMS(let param):
            return .requestJSONEncodable(param)
        case .checkNickName(let param):
            return .requestJSONEncodable(param)
        case .checkUser(let param):
            return .requestJSONEncodable(param)
        case .getPresignedURLServer(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .logout, .deleteUser, .getMarshmallow:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout, .deleteUser, .getMarshmallow:
            let token = UserManager.token ?? ""
            let header = [
                "Content-Type": "application/json",
                "ACCESS-TOKEN": token]
            return header
        default:
            return ["Content-Type": "application/json"]
        }
    }
}


struct ImageSendModel: Encodable{
    let image: Data
}
