//
//  PageableModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct PageableModel: Encodable{
    let page: Int
    let size: Int = Const.requestPagingSize
    let sort = ["string"]
}
