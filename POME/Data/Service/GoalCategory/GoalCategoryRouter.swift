//
//  GoalCategoryRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum GoalCategoryRouter: BaseRouter{
    case getGoalCategory
}

extension GoalCategoryRouter{
    var path: String {
        switch self {
        case .getGoalCategory:
            return HTTPMethodURL.GET.goalCategory
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGoalCategory:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getGoalCategory:
            let userId = UserManager.userId ?? ""
            return .requestParameters(parameters: ["userId": userId],
                                      encoding: URLEncoding.queryString)
        }
    }
}
