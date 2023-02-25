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
        let categoryText: Observable<String>
        let promiseText: Observable<String>
        let priceText: Observable<String>
//        let categoryTextFieldIsFocusing: Binder<Bool>
//        let promiseTextFieldIsFocusing: Binder<Bool>
//        let priceTextFieldIsFocusing: Binder<Bool>
    }
    
    struct Output{
        let categoryText: Driver<String>
        let promiseText: Driver<String>
        let priceText: Driver<String>
//        let cateogryIsFocus: Driver<Bool>
//        let promiseIsFocus: Driver<Bool>
//        let priceIsFocus: Driver<Bool>
        let canMoveNext: Driver<Bool>
    }
    
    init(goalUseCase: CreateGoalUseCase){
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
            .map{ $0 }
            .asDriver(onErrorJustReturn: "")
        
//        let cateogryIsFocus = input.categoryTextFieldIsFocusing
//            .asDriver(onErrorJustReturn: false)
//
//        let promiseIsFocus = input.categoryTextFieldIsFocusing
//            .map{ $0 }
//            .asDriver(onErrorJustReturn: false)
//
//        let priceIsFocus = input.categoryTextFieldIsFocusing
//            .map{ $0 }
//            .asDriver(onErrorJustReturn: false)
        
        let canMoveNext = requestObservable
            .map { category, promise, price in
                return !category.isEmpty && !promise.isEmpty && !price.isEmpty
            }.asDriver(onErrorJustReturn: false)

        return Output(categoryText: category,
                      promiseText: promise,
                      priceText: price,
//                      cateogryIsFocus: cateogryIsFocus,
//                      promiseIsFocus: promiseIsFocus,
//                      priceIsFocus: priceIsFocus,
                      canMoveNext: canMoveNext)
    }
}

