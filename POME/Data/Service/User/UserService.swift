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
    
    func sendSMS(model: PhoneNumRequestModel, completion: @escaping (Result<BaseResponseModel<SendSMSResponseModel>, Error>) -> Void) {
        requestDecoded(UserRouter.sendSMS(param: model)) { response in
            completion(response)
        }
    }
    
    func checkNickName(model: CheckNicknameRequestModel, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        requestDecoded(UserRouter.checkNickName(param: model)) { response in
            completion(response)
        }
    }
    
    func checkUser(model: PhoneNumRequestModel, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        requestDecoded(UserRouter.checkUser(param: model)) { response in
            completion(response)
        }
    }
    
    func getPresignedURL(id: String, completion: @escaping (Result<PresignedURLResponseModel, Error>) -> Void) {
        requestDecoded(UserRouter.getPresignedURLServer(id: id)) { response in
            completion(response)
        }
    }
    
    func uploadToBinary(url: String, image: UIImage, compeltion: @escaping (String) -> Void) {
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
        compeltion(url)
    }
}

