//
//  MarshmallowRepository.swift
//  POME
//
//  Created by gomin on 2023/05/26.
//

import Foundation
import RxSwift

class MarshmallowRepository: MarshmallowRepositoryInterface{
        
    func getMarshmallows() -> Observable<MarshmallowResponseModel> {
        let observable = Observable<MarshmallowResponseModel>.create { observer -> Disposable in
            let requestReference: () = UserService.shared.getMarshmallow { response in
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
