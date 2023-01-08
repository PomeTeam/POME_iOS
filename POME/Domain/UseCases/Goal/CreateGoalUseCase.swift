//
//  CreateGoalUseCase.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation

protocol CreateGoalUseCase{
    func createGoal()
}

class DefaultCreateGoalUseCase: CreateGoalUseCase{
    
    private let goalRepository: DefaultGoalRepository
    
    init(goalRepository: DefaultGoalRepository){
        self.goalRepository = goalRepository
    }
    
    func createGoal() {
        
    }
    
    
}
