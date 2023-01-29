//
//  GoalResponseModel.swift
//  POME
//
//  Created by gomin on 2023/01/29.
//

import Foundation

struct GoalResponseModel: Decodable {
    let endDate: String
    let goalCategoryResponse: GoalCategoryResponseModel
    let id: Int
    let isPublic: Bool
    let nickname: String
    let oneLineMind: String
    let price: Int
    let startDate: String
}

