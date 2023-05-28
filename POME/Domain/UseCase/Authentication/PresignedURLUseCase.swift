//
//  PresignedURLUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift

protocol PresignedURLUseCaseInterface {
    func execute(id: String) -> Observable<PresignedURLResponseModel>
    func saveToImgServer(url: String, image: UIImage)
}

final class PresignedURLUseCase: PresignedURLUseCaseInterface {

    private let userRepository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(id: String) -> Observable<PresignedURLResponseModel>{
        return userRepository.getPresignedURL(id: id)
    }
    
    func saveToImgServer(url: String, image: UIImage) {
        return userRepository.putImgServer(url: url, image: image)
    }
}
