//
//  BaseViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation
import RxSwift

protocol BaseViewModel{
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}
