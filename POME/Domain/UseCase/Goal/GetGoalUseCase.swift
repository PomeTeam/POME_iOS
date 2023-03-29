//
//  GetGoalUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol GetGoalUseCaseInterface {
    func execute() -> Observable<[GoalResponseModel]>
}

final class GetGoalUseCase: GetGoalUseCaseInterface {

    private let goalRepository: GoalRepositoryInterface

    init(goalRepository: GoalRepositoryInterface = GoalRepository()) {
        self.goalRepository = goalRepository
    }

    func execute() -> Observable<[GoalResponseModel]>{
        return goalRepository.getGoals()
    }
}
