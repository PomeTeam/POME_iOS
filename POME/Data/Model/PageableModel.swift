//
//  PageableModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct PageableModel: Encodable{
    let page: Int
    let size: Int
    let sort = ["string"]
}


protocol ConvertDictionary{
}

extension ConvertDictionary where Self: Encodable{
    /*
    var dictionary: [String : Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { throw NSError() }
        return dictionary
    }
     */
}
