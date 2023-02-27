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
        let isHighlightStartDateIcon: Driver<Bool>
        let isHighlightEndDateIcon: Driver<Bool>
        let canSelectEndDate: Driver<Bool>
        let willShowInvalidationLabel: Driver<Bool>
        let canMoveNext: Driver<Bool>
    }
    
    init(goalUseCase: CreateGoalUseCase){
        self.goalUseCase = goalUseCase
    }
    
    func transform(input: Input) -> Output{
        
        let requestObservable = Observable.combineLatest(input.startDateTextField, input.endDateTextField)
        
        let isHighlightStartDateIcon = input.startDateTextField
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let isHighlightEndDateIcon = input.endDateTextField
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let canSelectEndDate = input.startDateTextField
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let isValidation: Observable<Bool> = requestObservable
            .map{ startDate, endDate in
                if(startDate.isEmpty || endDate.isEmpty){
                    return false
                }
                
                let start = PomeDateFormatter.getDateType(from: startDate)
                let validateEndDate = Calendar.current.date(byAdding: .day, value: 31, to: start) ?? Date()
                let validateEndDateString = PomeDateFormatter.getDateString(validateEndDate)
                
                return endDate <= validateEndDateString && endDate > startDate ? true : false
            }.share()
        
        let willShowInvalidationLabel = requestObservable
            .map{ startDate, endDate in
                if(startDate.isEmpty || endDate.isEmpty){
                    return true
                }
                let start = PomeDateFormatter.getDateType(from: startDate)
                let validateEndDate = Calendar.current.date(byAdding: .day, value: 31, to: start) ?? Date()
                let validateEndDateString = PomeDateFormatter.getDateString(validateEndDate)
                
                return endDate <= validateEndDateString && endDate > startDate ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        let canMoveNext = isValidation
            .map { $0 }
            .asDriver(onErrorJustReturn: false)

        return Output(isHighlightStartDateIcon: isHighlightStartDateIcon,
                      isHighlightEndDateIcon: isHighlightEndDateIcon,
                      canSelectEndDate: canSelectEndDate,
                      willShowInvalidationLabel: willShowInvalidationLabel,
                      canMoveNext: canMoveNext
        )
    }
}
