//
//  GetFinishedGoalsUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/26.
//

import Foundation
import RxSwift

protocol GetFinishedGoalsUseCaseInterface {
    func execute() -> Observable<[GoalResponseModel]>
}

final class GetFinishedGoalsUseCase: GetFinishedGoalsUseCaseInterface {

    private let goalRepository: GoalRepositoryInterface

    init(goalRepository: GoalRepositoryInterface = GoalRepository()) {
        self.goalRepository = goalRepository
    }

    func execute() -> Observable<[GoalResponseModel]>{
//        let finishedGoalsCount = goalRepository.getFinishedGoals()
//            .map { [self] in
//            $0.count
//        }
        return goalRepository.getFinishedGoals()
    }
}


