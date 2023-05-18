//
//  GenerateGoalUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

struct GenerateGoalRequestModel: Encodable{
    let name: String
    let startDate: String
    let endDate: String
    let oneLineMind: String
    let price: Int
    let isPublic: Bool
}

protocol GenerateGoalUseCaseInterface {
    func execute(requestValue: GenerateGoalRequestModel) -> Observable<GenerateGoalStatus>
}

final class GenerateGoalUseCase: GenerateGoalUseCaseInterface {

    private let goalRepository: GoalRepositoryInterface

    init(goalRepository: GoalRepositoryInterface = GoalRepository()) {
        self.goalRepository = goalRepository
    }

    func execute(requestValue: GenerateGoalRequestModel) -> Observable<GenerateGoalStatus>{
        return goalRepository.generateGoal(requestValue: requestValue)
    }
}
