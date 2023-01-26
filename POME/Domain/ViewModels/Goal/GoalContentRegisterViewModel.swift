//
//  GoalContentRegisterViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation
import RxSwift
import RxCocoa

class GoalContentRegisterViewModel{
    
    private let goalUseCase: CreateGoalUseCase
    
    struct Input{
        let categoryTextField: Observable<String>
        let promiseTextField: Observable<String>
        let priceTextField: Observable<String>
    }
    
    struct Output{
        let category: Driver<String>
        let promise: Driver<String>
        let price: Driver<String>
        let canMoveNext: Driver<Bool>
    }
    
    init(goalUseCase: CreateGoalUseCase){
        self.goalUseCase = goalUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let requestObservable = Observable.combineLatest(input.categoryTextField,
                                                         input.promiseTextField,
                                                         input.priceTextField)
        
        
        let category = input.categoryTextField
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
        let promise = input.promiseTextField
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
        let price = input.priceTextField
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
        let canMoveNext = requestObservable
            .map { category, promise, price in
                return !category.isEmpty && !promise.isEmpty && !price.isEmpty
            }.asDriver(onErrorJustReturn: false)

        return Output(category: category,
                      promise: promise,
                      price: price,
                      canMoveNext: canMoveNext)
    }
}

