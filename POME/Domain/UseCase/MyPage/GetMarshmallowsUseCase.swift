//
//  GetMarshmallowsUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/26.
//

import Foundation
import RxSwift

protocol GetMarshmallowsUseCaseInterface {
    func execute() -> Observable<MarshmallowResponseModel>
}

final class GetMarshmallowsUseCase: GetMarshmallowsUseCaseInterface {

    private let marshmallowRepository: MarshmallowRepositoryInterface

    init(marshmallowRepository: MarshmallowRepositoryInterface = MarshmallowRepository()) {
        self.marshmallowRepository = marshmallowRepository
    }

    func execute() -> Observable<MarshmallowResponseModel>{
        return marshmallowRepository.getMarshmallows()
    }
}


