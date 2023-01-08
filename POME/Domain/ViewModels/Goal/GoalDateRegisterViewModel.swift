//
//  GoalDateRegisterViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation

class GoalDateRegisterViewModel{
    
    private let goalUseCase: CreateGoalUseCase
    
    struct Input{
        
    }
    
    struct Output{
        
    }
    
    init(goalUseCase: CreateGoalUseCase){
        self.goalUseCase = goalUseCase
    }
    
    func transform(input: Input) -> Output{
        return Output()
    }
}
