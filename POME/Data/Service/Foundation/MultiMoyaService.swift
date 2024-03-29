//
//  MultiMoyaProvider.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

class MultiMoyaService: MoyaProvider<MultiTarget> {
    
    var request: Cancellable?
    
    //TODO: WILL DELETE
    func requestDecoded<T: BaseRouter, L: Decodable>(_ target: T,
                                                     completion: @escaping (Result<L, Error>) -> Void) {
        addObserver()
        request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(L.self, from: response.data)
                    completion(.success(body))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func requestDecoded<T: BaseRouter, L: Decodable>(_ target: T, completion: @escaping ((NetworkResult<L>) -> Void)) {
        addObserver()
        request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let body = try JSONDecoder().decode(BaseResponseModel<L>.self, from: response.data)
                    if(body.success){
                        if let data = body.data{
                            completion(.success(data))
                        }
                    }else{
                        completion(.invalidSuccess(body.errorCode ?? "", body.message ))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestDecoded<T: BaseRouter, L: Decodable>(_ target: T, animate: Bool, completion: @escaping ((NetworkResult<L>) -> Void)) {
        addObserver()
        if(animate){
            LoadingView.show()
        }
        request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let body = try JSONDecoder().decode(BaseResponseModel<L>.self, from: response.data)
                    if(body.success){
                        if let data = body.data{
                            completion(.success(data))
                        }
                    }else{
                        if(body.httpCode == 406 || body.httpCode == 403){
                            self.requestGenerateAccessToken()
                            return
                        }else{
                            completion(.invalidSuccess(body.errorCode ?? "", body.message ))
                        }
                    }
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

        LoadingView.hide()
        print("LOG: LoadingView HIDE")
    }

//    //TODO: - WILL DELETE
    func requestNoResultAPI<T: BaseRouter>(_ target: T,
                                               completion: @escaping (Result<Int, Error>) -> Void) {
        addObserver()
        request = request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.statusCode))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestNoResultAPI<T: BaseRouter>(_ target: T,
                                           completion: @escaping (NetworkResult<Any>) -> Void) {
        addObserver()
        request = request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let body = try JSONDecoder().decode(StatusResponseModel.self, from: response.data)
                    if(body.success){
                        completion(.success(body.success))
                    }else{
                        completion(.invalidSuccess(body.errorCode ?? "", body.message))
                    }
                } catch let error {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestNoResultAPI<T: BaseRouter>(_ target: T,
                                           animate: Bool,
                                           completion: @escaping (NetworkResult<Any>) -> Void) {
        addObserver()
        if(animate){
            LoadingView.show()
        }
        request = request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let body = try JSONDecoder().decode(StatusResponseModel.self, from: response.data)
                    if(body.success){
                        completion(.success(body.success))
                    }else{
                        if(body.httpCode == 406 || body.httpCode == 403){
                            self.requestGenerateAccessToken()
                        }else{
                            completion(.invalidSuccess(body.errorCode ?? "", body.message ))
                        }
                    }
                } catch let error {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        LoadingView.hide()
        print("LOG: LoadingView HIDE")
    }
    
    func requestWithProgress<T: BaseRouter>(_ target: T,
                                                progressCompletion: @escaping ((ProgressResponse) -> Void),
                                                completion: @escaping (Result<Int?, Error>) -> Void) {
        addObserver()
        request = request(MultiTarget(target)) { progress in
            progressCompletion(progress)
        } completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response.statusCode))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestDecodedMultiRepsonse<T: BaseRouter, R: Decodable>(_ target: T,
                                                                      _ requestModel: R.Type,
                                                                      completion: @escaping (Result<R?, Error>) -> Void) {
        addObserver()
        request = request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let body = try JSONDecoder().decode(R.self, from: response.data)
                    completion(.success(body))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestGenerateAccessToken(){
//        AuthService.shared.generateAccessToken{ response in
//            switch response{
//            case .success(let token):
//                print("LOG: SUCCESS requestGenerateAccessToken", token)
//                UserManager.token = token
//                break
//            default:
//                print("LOG: INVALID SUCCESS requestGenerateAccessToken")
//                self.requestGenerateAccessToken()
//            }
//        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelRequest),
                                               name: Notification.Name("requestCancel"),
                                               object: nil)
    }
    
    @objc func cancelRequest(notification: NSNotification) {
        guard let request = request else {
            return
        }
        request.cancel()
    }
    
}
