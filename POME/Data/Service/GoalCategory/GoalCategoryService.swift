//
//  GoalCategoryService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class GoalCategoryService: MultiMoyaService{
    static let shared = GoalCategoryService()
    private init() { }
}

extension GoalCategoryService{
    func getGoalCategory(completion: @escaping (Result<BaseResponseModel<[GoalCategoryResponseModel]>, Error>) -> Void){
        requestDecoded(GoalCategoryRouter.getGoalCategory){ response in
            completion(response)
        }
    }
}
