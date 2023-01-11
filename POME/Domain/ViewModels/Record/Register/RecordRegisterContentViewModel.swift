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
        
        let canMoveNext = requestObservable
            .map{ category, date, price, detail in
                !category.isEmpty && !date.isEmpty && !price.isEmpty && detail != input.detailTextViewplaceholder && !detail.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        return Output(canMoveNext: canMoveNext)
    }
}
