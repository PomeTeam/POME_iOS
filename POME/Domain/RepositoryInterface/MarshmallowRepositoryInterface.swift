//
//  MarshmallowRepositoryInterface.swift
//  POME
//
//  Created by gomin on 2023/05/26.
//

import Foundation
import RxSwift

protocol MarshmallowRepositoryInterface{
    func getMarshmallows() -> Observable<MarshmallowResponseModel>
}
