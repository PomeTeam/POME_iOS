//
//  GoalServcie.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class GoalService: MultiMoyaService{
    static let shared = GoalService()
    private init() { }
}

extension GoalService{
    
    func generateGoal(request: GoalRegisterRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestNoResultAPI(GoalRouter.postGoal(request: request), animate: true){ response in
            completion(response)
        }
    }
    
    func getGoal(id: Int, completion: @escaping (Result<BaseResponseModel<GoalResponseModel>, Error>) -> Void) {
        requestDecoded(GoalRouter.getGoal(id: id)) { response in
            completion(response)
        }
    }
    
    func modifyGoal(id: Int, request: GoalRegisterRequestModel,completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(GoalRouter.putGoal(id: id, request: request)){ response in
            completion(response)
        }
    }
    
    func deleteGoal(id: Int, completion: @escaping (Result<BaseResponseModel<Bool>, Error>) -> Void) {
        requestDecoded(GoalRouter.deleteGoal(id: id)) { response in
            completion(response)
        }
    }
    
    func getUserGoals(completion: @escaping (NetworkResult<PageableResponseModel<GoalResponseModel>>) -> Void) {
        requestDecoded(GoalRouter.getGoals, animate: true){ response in
            completion(response)
        }
    }
    
    func finishGoal(id: Int, param: FinishGoalRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestNoResultAPI(GoalRouter.finishGoal(id: id, param: param)){ response in
            completion(response)
        }
    }
    
    func getFinishedGoals(completion: @escaping (NetworkResult<PageableResponseModel<GoalResponseModel>>) -> Void) {
        requestDecoded(GoalRouter.getFinishedGoals){ response in
            completion(response)
        }
    }
}
