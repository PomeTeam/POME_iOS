//
//  UserRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum UserRouter: BaseRouter{
    case signUp(param: SignUpRequestModel)
    case signIn(param: SignInRequestModel)
    case sendSMS(param: SendSMSRequestModel)
    
    case imageServer(id: String)
}

extension UserRouter{
    
    var baseURL: URL {
        switch self {
        case .imageServer:
            return URL(string: "http://image-main-server.ap-northeast-2.elasticbeanstalk.com/presigned-url")!
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
        case .imageServer:
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
        case .imageServer(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        }
    }
}
