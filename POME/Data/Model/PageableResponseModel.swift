//
//  PageableResponseModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/30.
//

import Foundation

struct PageableResponseModel<T: Decodable>: Decodable{
    let content: [T]
    let empty: Bool
    let last: Bool
}

