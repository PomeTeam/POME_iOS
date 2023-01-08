//
//  GoalRepository.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation

protocol GoalRepository{
    func create(request: Goal)
}

class DefaultGoalRepository: GoalRepository{
    func create(request: Goal) {
        //GoalService.shared... API 호출
    }
}
