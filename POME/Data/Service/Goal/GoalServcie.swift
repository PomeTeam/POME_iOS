//
//  GoalServcie.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class GoalServcie: MultiMoyaService{
    static let shared = GoalServcie()
    private init() { }
}

extension GoalServcie{
    
    func generateGoal(request: GoalRegisterRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        requestNoResultAPI(GoalRouter.postGoal(request: request)){ response in
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
    
    func deleteGoal(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(GoalRouter.deleteGoal(id: id)){ response in
            completion(response)
        }
    }
    
    func getUserGoals(completion: @escaping (NetworkResult<PageableResponseModel<[GoalResponseModel]>>) -> Void) {
        requestDecoded(GoalRouter.getGoals){ response in
            completion(response)
        }
    }
}
