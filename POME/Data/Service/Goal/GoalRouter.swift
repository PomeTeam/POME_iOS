//
//  GoalRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum GoalRouter: BaseRouter{
    case postGoal(request: GenerateGoalRequestModel)
    case getGoal(id: Int)
    case deleteGoal(id: Int)
    case getGoals
    case finishGoal(id: Int, param: FinishGoalRequestModel)
    case getFinishedGoals
}

extension GoalRouter{
    var path: String {
        switch self {
        case .postGoal:
            return HTTPMethodURL.POST.goal
        case .getGoal(let id):
            return HTTPMethodURL.GET.goal + "/\(id)"
        case .deleteGoal(let id):
            return HTTPMethodURL.DELETE.goal +  "/\(id)"
        case .getGoals:
            return HTTPMethodURL.GET.goals
        case .finishGoal(let id, _):
            return HTTPMethodURL.PUT.finishGoal +  "/\(id)"
        case .getFinishedGoals:
            return HTTPMethodURL.GET.finishedGoals
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .postGoal:
            return .post
        case .getGoal:
            return .get
        case .deleteGoal:
            return .delete
        case .getGoals:
            return .get
        case .finishGoal:
            return .put
        case .getFinishedGoals:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .postGoal(let request):
            return .requestJSONEncodable(request)
        case .getGoal:
            return .requestPlain
        case .deleteGoal:
            return .requestPlain
        case .getGoals:
            return .requestParameters(parameters: ["sort": "endDate,desc"], encoding: URLEncoding.queryString)
        case .finishGoal(_, let param):
            return .requestJSONEncodable(param)
        case .getFinishedGoals:
            return .requestPlain
        }
    }
}
