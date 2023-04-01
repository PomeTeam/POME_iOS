//
//  GoalDateRegisterViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

class GoalDateRegisterViewModel{
    
    private let startDateSubject = PublishSubject<String>()
    private let endDateSubject = PublishSubject<String>()
    
    
    struct Input{
        let ctaButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let startDate: Driver<String>
        let endDate: Driver<String>
        let isHighlightStartDateIcon: Driver<Bool>
        let isHighlightEndDateIcon: Driver<Bool>
        let canSelectEndDate: Driver<Bool>
        let willShowInvalidationLabel: Driver<Bool>
        let canMoveNext: Driver<Bool>
        let goalDateRange: Observable<GoalDateDTO>
    }
    
    func transform(input: Input) -> Output{
        
        let dateRangeObservable = Observable.combineLatest(startDateSubject, endDateSubject)
        
        let isHighlightStartDateIcon = startDateSubject
            .first()
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        
        let isHighlightEndDateIcon = endDateSubject
            .first()
            .map{ _ in true }
            .asDriver(onErrorJustReturn: false)
        
        let startDate = startDateSubject
            .asDriver(onErrorJustReturn: "")
        
        let endDate = endDateSubject
            .asDriver(onErrorJustReturn: "")
        
        let canSelectEndDate = startDateSubject
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let isDateEmpty: Observable<Bool> = dateRangeObservable
            .map{ startDate, endDate in
                startDate.isEmpty || endDate.isEmpty
            }
        
        let isDateValidate: Observable<Bool> = dateRangeObservable
            .map{ startDate, endDate in
                let start = PomeDateFormatter.getDateType(from: startDate)
                let validateEndDate = Calendar.current.date(byAdding: .day, value: 31, to: start) ?? Date()
                let validateEndDateString = PomeDateFormatter.getDateString(validateEndDate)
                return endDate <= validateEndDateString && endDate > startDate ? true : false
            }
        
        let dateValidationObservable = Observable.zip(isDateEmpty, isDateValidate)
        
        let willShowInvalidationLabel = dateValidationObservable
            .map{ isEmpty, isValidate in
                return isEmpty ? true : isValidate
            }.asDriver(onErrorJustReturn: false)
        
        let canMoveNext = dateValidationObservable
            .map{ isEmpty, isValidate in
                return isEmpty ? false : isValidate
            }.asDriver(onErrorJustReturn: false)
        
        let goalDateRange = input.ctaButtonTap
            .withLatestFrom(dateRangeObservable)
            .map{ start, end in
                GoalDateDTO(startDate: start, endDate: end)
            }.share()

        return Output(startDate: startDate,
                      endDate: endDate,
                      isHighlightStartDateIcon: isHighlightStartDateIcon,
                      isHighlightEndDateIcon: isHighlightEndDateIcon,
                      canSelectEndDate: canSelectEndDate,
                      willShowInvalidationLabel: willShowInvalidationLabel,
                      canMoveNext: canMoveNext,
                      goalDateRange: goalDateRange)
    }
}


extension GoalDateRegisterViewModel: CalendarViewModel{
    func selectDate(tag: Int, _ date: String) {
        switch CalendarDate(rawValue: tag){
        case .start:
            startDateSubject.onNext(date)
        case .end:
            endDateSubject.onNext(date)
        default:
            fatalError()
        }
    }
}
