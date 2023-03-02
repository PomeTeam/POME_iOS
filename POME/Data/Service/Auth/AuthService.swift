//
//  AuthService.swift
//  POME
//
//  Created by 박소윤 on 2023/03/02.
//

import Foundation
import Moya

final class AuthService{
    static let shared = AuthService()
    private init() { }
    let provider = MultiMoyaService(plugins: [MoyaLoggerPlugin()])
}

extension AuthService{
    func generateAccessToken(completion: @escaping (NetworkResult<String>) -> Void) {
        provider.requestDecoded(AuthRouter.renewAccessToken, animate: true){ response in
            completion(response)
        }
    }
}
