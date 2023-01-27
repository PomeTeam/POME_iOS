//
//  GoalRegisterRequestModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct GoalRegisterRequestModel: Encodable{
    let name: String
    let startDate: String
    let endDate: String
    let oneLineMind: String
    let price: Int
    let isPublic: Bool
}
