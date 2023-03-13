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
        
        let isDateEmpty: Observable<Bool> = requestObservable
            .map{ startDate, endDate in
                startDate.isEmpty || endDate.isEmpty
            }
        
        let isDateValidate: Observable<Bool> = requestObservable
            .map{ startDate, endDate in
                let start = PomeDateFormatter.getDateType(from: startDate)
                let validateEndDate = Calendar.current.date(byAdding: .day, value: 31, to: start) ?? Date()
                let validateEndDateString = PomeDateFormatter.getDateString(validateEndDate)
                return endDate <= validateEndDateString && endDate > startDate ? true : false
            }
        
        let dateValidationObservable = Observable.zip(isDateEmpty, isDateValidate)
        
        let willShowInvalidationLabel = dateValidationObservable
            .map{ isEmpty, isValidate in
                print("willShowInvalidationLabel")
                return isEmpty ? true : isValidate
            }.asDriver(onErrorJustReturn: false)
        
        let canMoveNext = dateValidationObservable
            .map{ isEmpty, isValidate in
                print("canMoveNext")
                return isEmpty ? false : isValidate
            }.asDriver(onErrorJustReturn: false)

        return Output(isHighlightStartDateIcon: isHighlightStartDateIcon,
                      isHighlightEndDateIcon: isHighlightEndDateIcon,
                      canSelectEndDate: canSelectEndDate,
                      willShowInvalidationLabel: willShowInvalidationLabel,
                      canMoveNext: canMoveNext
        )
    }
}
