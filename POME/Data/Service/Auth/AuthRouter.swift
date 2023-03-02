//
//  AuthRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/03/02.
//

import Foundation
import Moya

enum AuthRouter: BaseRouter{
    case renewAccessToken
}

extension AuthRouter{
    
    var path: String {
        switch self {
        case .renewAccessToken:
            return HTTPMethodURL.POST.authRenew
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .renewAccessToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .renewAccessToken:
            return .requestJSONEncodable(RenewRequestModel())
        }
    }
}
