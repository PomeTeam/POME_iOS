//
//  UserService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class UserService: MultiMoyaService{
    static let shared = UserService()
    private init() { }
}

extension UserService{
    
    func signUp(model: SignUpRequestModel, completion: @escaping (Result<BaseResponseModel<UserModel>, Error>) -> Void) {
        requestDecoded(UserRouter.signUp(param: model)){ response in
            completion(response)
        }
    }
    
    func signIn(model: SignInRequestModel, completion: @escaping (Result<BaseResponseModel<UserModel>, Error>) -> Void) {
        requestDecoded(UserRouter.signIn(param: model)){ response in
            completion(response)
        }
    }
    
    func sendSMS(model: SendSMSRequestModel, completion: @escaping (Result<BaseResponseModel<SendSMSResponseModel>, Error>) -> Void) {
        requestDecoded(UserRouter.sendSMS(param: model)) { response in
            completion(response)
        }
    }
}
