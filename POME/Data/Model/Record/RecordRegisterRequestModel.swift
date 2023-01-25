//
//  RecordRequestModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct RecordRegisterRequestModel: Encodable{
    let goalId: Int
    let emotionId: Int
    let usePrice: Int
    let useDate: String
    let useComment: String
}
