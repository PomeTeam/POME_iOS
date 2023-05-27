//
//  UserRepository.swift
//  POME
//
//  Created by gomin on 2023/05/27.
//

import Foundation
import RxSwift

class UserRepository: UserRepositoryInterface{
    
    func sendCode(requestValue: PhoneNumRequestModel) -> Observable<SendSMSResponseModel> {
        let observable = Observable<SendSMSResponseModel>.create { observer -> Disposable in
            let requestReference: () = UserService.shared.sendSMS(requestValue: requestValue) { response in
                switch response {
                case .success(let data):
                    observer.onNext(data.data!)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func checkUser(requestValue: PhoneNumRequestModel) -> Observable<Bool> {
        let observable = Observable<Bool>.create { observer -> Disposable in
            let requestReference: () = UserService.shared.checkUser(model: requestValue) { response in
                switch response {
                case .success(let data):
                    // data.data가 true면 유저, false면 유저 아님 -> 회원가입
                    observer.onNext(data.data ?? false)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func signIn(requestValue: SignInRequestModel) -> Observable<UserModel> {
        let observable = Observable<UserModel>.create { observer -> Disposable in
            let requestReference: () = UserService.shared.signIn(requestValue: requestValue) { response in
                switch response {
                case .success(let data):
                    observer.onNext(data)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
}
