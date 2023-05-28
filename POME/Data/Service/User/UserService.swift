//
//  UserService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

final class UserService{
    static let shared = UserService()
    private init() { }
    let provider = MultiMoyaService(plugins: [MoyaLoggerPlugin()])
}

extension UserService{
    
    func signUp(model: SignUpRequestModel, completion: @escaping (Result<BaseResponseModel<UserModel>, Error>) -> Void) {
        provider.requestDecoded(UserRouter.signUp(param: model)){ response in
            completion(response)
        }
    }
    
    func signIn(requestValue: SignInRequestModel, completion: @escaping (NetworkResult<UserModel>) -> Void) {
        provider.requestDecoded(UserRouter.signIn(param: requestValue), animate: true){ response in
            completion(response)
        }
    }
    
    func logout(completion: @escaping (NetworkResult<Bool>) -> Void) {
        provider.requestDecoded(UserRouter.logout){ response in
            completion(response)
        }
    }
    
    func deleteUser(reason: String, completion: @escaping (NetworkResult<Bool>) -> Void) {
        provider.requestDecoded(UserRouter.deleteUser(reason: reason)){ response in
            completion(response)
        }
    }
    
    func getMarshmallow(completion: @escaping (NetworkResult<MarshmallowResponseModel>) -> Void) {
        provider.requestDecoded(UserRouter.getMarshmallow){ response in
            completion(response)
        }
    }
    
    func sendSMS(requestValue: PhoneNumRequestModel, completion: @escaping (Result<BaseResponseModel<SendSMSResponseModel>, Error>) -> Void) {
        provider.requestDecoded(UserRouter.sendSMS(param: requestValue)) { response in
            completion(response)
        }
    }
    
    func checkNickName(model: CheckNicknameRequestModel, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        provider.requestDecoded(UserRouter.checkNickName(param: model)) { response in
            completion(response)
        }
    }
    
    func checkUser(model: PhoneNumRequestModel, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        provider.requestDecoded(UserRouter.checkUser(param: model)) { response in
            completion(response)
        }
    }
    
    func getPresignedURL(id: String, completion: @escaping (Result<PresignedURLResponseModel, Error>) -> Void) {
        provider.requestDecoded(UserRouter.getPresignedURLServer(id: id)) { response in
            completion(response)
        }
    }
    
    func uploadToBinary(url: String, image: UIImage, completion: @escaping (String) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)
        
        let imageToData = image.jpegData(compressionQuality: 1)
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = imageToData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                semaphore.signal()
                return
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        completion(url)
    }
}

