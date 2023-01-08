//
//  GoalDateRegisterViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation
import RxSwift
import RxCocoa

class GoalDateRegisterViewModel{
    
    private let goalUseCase: CreateGoalUseCase
    
    struct Input{
        let startDateTextField: Observable<String>
        let endDateTextField: Observable<String>
        let completeButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let canMoveNext: Driver<Bool>
    }
    
    init(goalUseCase: CreateGoalUseCase){
        self.goalUseCase = goalUseCase
    }
    
    func transform(input: Input) -> Output{
        
        let requestObservable = Observable.combineLatest(input.startDateTextField, input.endDateTextField)
        
        let canMoveNext = requestObservable
            .map { startDate, endDate in
                return !startDate.isEmpty && !endDate.isEmpty
            }.asDriver(onErrorJustReturn: false)

        return Output(canMoveNext: canMoveNext)
    }
}
