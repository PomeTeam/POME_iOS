//
//  GoalContentRegisterViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation
import RxSwift
import RxCocoa

class GenerateGoalContentViewModel{
    
    private let goalUseCase: GenerateGoalUseCase
    
    struct Input{
        let categoryText: Observable<String>
        let promiseText: Observable<String>
        let priceText: Observable<String>
    }
    
    struct Output{
        let categoryText: Driver<String>
        let promiseText: Driver<String>
        let priceText: Driver<String>
        let canMoveNext: Driver<Bool>
    }
    
    init(goalUseCase: GenerateGoalUseCase = GenerateGoalUseCase()){
        self.goalUseCase = goalUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let requestObservable = Observable.combineLatest(input.categoryText,
                                                         input.promiseText,
                                                         input.priceText)
        
        
        let category = input.categoryText
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
        let promise = input.promiseText
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
        let price = input.priceText
            .map{ $0.replacingOccurrences(of: ",", with: "") }
            .asDriver(onErrorJustReturn: "")
        
        let canMoveNext = requestObservable
            .map { category, promise, price in
                return !category.isEmpty && !promise.isEmpty && !price.isEmpty && Int(price.replacingOccurrences(of: ",", with: ""))! > 0
            }.asDriver(onErrorJustReturn: false)

        return Output(categoryText: category,
                      promiseText: promise,
                      priceText: price,
                      canMoveNext: canMoveNext)
    }
}

