//
//  RecordDTO.swift
//  POME
//
//  Created by 박소윤 on 2023/03/30.
//

import Foundation

struct RecordDTO: Encodable{ //기록 생성시 VC 간 데이터 전달용 구조체
    let goalId: Int
    let useComment: String
    let useDate: String
    let usePrice: Int
}
