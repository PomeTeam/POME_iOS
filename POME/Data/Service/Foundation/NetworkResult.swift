//
//  NetworkResult.swift
//  POME
//
//  Created by 박소윤 on 2023/01/29.
//

import Foundation

enum NetworkResult<T>{
    typealias Code = String
    typealias Message = String
    case success(T)
    case invalidSuccess(Code, Message)
    case failure(Error?)
}
