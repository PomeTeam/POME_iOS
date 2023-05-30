//
//  DeleteGoalUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift

protocol DeleteGoalUseCaseInterface {
    func execute(id: Int) -> Observable<BaseResponseStatus>
}

final class DeleteGoalUseCase: DeleteGoalUseCaseInterface {

    private let goalRepository: GoalRepositoryInterface

    init(goalRepository: GoalRepositoryInterface = GoalRepository()) {
        self.goalRepository = goalRepository
    }

    func execute(id: Int) -> Observable<BaseResponseStatus>{
        return goalRepository.deleteGoal(id: id)
    }
}
