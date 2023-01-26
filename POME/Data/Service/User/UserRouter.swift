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
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signUp:
            return HTTPMethodURL.POST.signUp
        case .signIn:
            return HTTPMethodURL.POST.signIn
        case .sendSMS:
            return HTTPMethodURL.POST.sms
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
        }
    }
}
