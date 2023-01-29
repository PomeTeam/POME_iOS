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
    
    func generateGoal(request: GoalRegisterRequestModel, completion: @escaping (Result<StatusResponseModel, Error>) -> Void) {
        requestDecoded(GoalRouter.postGoal(request: request)){ response in
            completion(response)
        }
//        requestNoResultAPI(GoalRouter.postGoal(request: request)){ response in
//            completion(response)
//        }
    }
    
    func getGoal(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(GoalRouter.getGoal(id: id)){ response in
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
    
    func getGoalByCategory(id: Int, pageable: PageableModel, completion: @escaping (Result<[FriendsResponseModel], Error>) -> Void) {
        requestDecoded(GoalRouter.getGoalsByCategory(id: id, pageable: pageable)){ response in
            completion(response)
        }
    }
}
