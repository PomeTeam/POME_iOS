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
    let usePrice: Int
    let oneLineComment: String?
}

extension GoalResponseModel{
    
    static let numberFormatter = NumberFormatter().then{
        $0.numberStyle = .decimal
    }
    
    var goalNameBinding: String{
        self.goalCategoryResponse.name
    }
    var remainDateBinding: Int {
        let diff = PomeDateFormatter.getRemainDate(self.endDate)
        return diff
    }
    
    var usePriceBinding: String{
        // 가격 콤마 표시
        let result = GoalResponseModel.numberFormatter.string(from: NSNumber(value: self.usePrice)) ?? ""
        return "\(result)원"
    }
    var priceBinding: String {
        // 가격 콤마 표시
        let result = GoalResponseModel.numberFormatter.string(from: NSNumber(value: self.price)) ?? ""
        return "· \(result)원"
    }
    
    var isEnd: Bool{
        PomeDateFormatter.isDateEnd(self.endDate)
    }
}
