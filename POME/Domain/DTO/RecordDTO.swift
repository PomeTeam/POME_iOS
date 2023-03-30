//
//  RecordDTO.swift
//  POME
//
//  Created by 박소윤 on 2023/03/30.
//

import Foundation

struct RecordDTO: Encodable{
    let goalId: Int
    let useComment: String
    let useDate: String
    let usePrice: Int
}
