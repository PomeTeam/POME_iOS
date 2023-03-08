//
//  RecordRegisterContentViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa

class RecordRegisterContentViewModel{
    
    private let createRecordUseCase: CreateRecordUseCase
    
    struct Input{
        let cateogrySelect: Observable<String>
        let consumeDateSelect: Observable<String>
        let priceTextField: Observable<String>
        let detailTextView: Observable<String>
        let detailTextViewplaceholder: String
        let nextButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let highlightCalendarIcon: Driver<Bool>
        let canMoveNext: Driver<Bool>
    }
    
    init(createRecordUseCase: CreateRecordUseCase){
        self.createRecordUseCase = createRecordUseCase
    }
    
    func transform(input: Input) -> Output{
        
        let requestObservable = Observable.combineLatest(input.cateogrySelect,
                                                         input.consumeDateSelect,
                                                         input.priceTextField,
                                                         input.detailTextView)
        
        let highlightCalendarIcon = input.consumeDateSelect
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let canMoveNext = requestObservable
            .map{ category, date, price, detail in
                return !category.isEmpty && !date.isEmpty
                && !price.isEmpty && Int(price.replacingOccurrences(of: ",", with: ""))! > 0
                && detail != input.detailTextViewplaceholder
                && !detail.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        return Output(highlightCalendarIcon: highlightCalendarIcon,
                      canMoveNext: canMoveNext)
    }
}
