//
//  PageableResponseModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/30.
//

import Foundation

struct PageableResponseModel<T: Decodable>: Decodable{
    struct PageInfo: Decodable{
        let pageNumber: Int
    }
    let content: [T]
    let empty: Bool
    let last: Bool
    let pageable: PageInfo
}

extension PageableResponseModel{
    var page: Int{
        pageable.pageNumber
    }
}
