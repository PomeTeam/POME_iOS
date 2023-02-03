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
    let isEnd: Bool
    let usePrice: Int
}

extension GoalResponseModel{
    var goalNameBinding: String{
        self.goalCategoryResponse.name
    }
}
