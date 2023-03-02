//
//  AuthService.swift
//  POME
//
//  Created by 박소윤 on 2023/03/02.
//

import Foundation

final class AuthService: MultiMoyaService{
    static let shared = AuthService()
    private init() { }
}

extension AuthService{
    func generateAccessToken(completion: @escaping (NetworkResult<String>) -> Void) {
        requestDecoded(AuthRouter.renewAccessToken, animate: true){ response in
            completion(response)
        }
    }
}
