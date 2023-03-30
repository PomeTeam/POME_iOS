//
//  GoalRepositoryInterface.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol GoalRepositoryInterface{
    func getGoals() -> Observable<[GoalResponseModel]>
    func generateGoal()
    func deleteGoal()
}
