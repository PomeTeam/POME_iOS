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
    
    private let generateGoalUseCase: GenerateGoalUseCase
    
    init(generateGoalUseCase: GenerateGoalUseCase = GenerateGoalUseCase()){
        self.generateGoalUseCase = generateGoalUseCase
    }
    
    struct Input{
        let dateRange: GoalDateDTO
        let goal: Observable<String>
        let oneLineMind: Observable<String>
        let price: Observable<String>
        let isPublic: Observable<Bool>
        let ctaButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let categoryBinding: Driver<String>
        let oneLineMindBinding: Driver<String>
        let priceBinding: Driver<String>
        let isPublicBinding: Driver<Bool>
        let ctaButtonActivate: Driver<Bool>
        let generateGoalStatusCode: Observable<GenerateGoalStatus>
    }
    
    func transform(input: Input) -> Output {
        
        //8자 제한 필요
        let category = input.goal
            .map{
                TextConverter.getValidateRangeString($0, limit: 8)
            }.share()
        
        let categoryBinding = category
            .asDriver(onErrorJustReturn: "")
        
        //18자 제한 필요
        let oneLineMind = input.oneLineMind
            .map{
                TextConverter.getValidateRangeString($0, limit: 18)
            }.share()
        
        let oneLineMindBinding = oneLineMind
            .asDriver(onErrorJustReturn: "")
        
        //decimal 기능 추가
        let priceBinding = input.price
            .filter{
                !$0.isEmpty
            }.map{
                TextConverter.convertToDecimalFormat(number: $0)
            }.asDriver(onErrorJustReturn: "0")
        
        let price = input.price
            .filter{
                !$0.isEmpty
            }.map{
                Int($0.replacingOccurrences(of: ",", with: ""))!
            }
        
        let isPublicBinding = input.isPublic
            .asDriver(onErrorJustReturn: false)

        let goalContentObservable = Observable.combineLatest(category,
                                                         oneLineMind,
                                                         price,
                                                         input.isPublic)
        
        let canMoveNext = goalContentObservable
            .map { category, oneLineMind, price, isPublic in
                return !category.isEmpty && !oneLineMind.isEmpty && price > 0
            }.asDriver(onErrorJustReturn: false)
        
        let generateGoalStatusCode = input.ctaButtonTap
            .withLatestFrom(goalContentObservable)
            .map{ category, oneLineMind, price, isPublic in
                return GenerateGoalRequestModel(name: category,
                                         startDate: input.dateRange.startDate,
                                         endDate: input.dateRange.endDate,
                                         oneLineMind: oneLineMind,
                                         price: price,
                                         isPublic: isPublic)
            }.flatMap{
                self.generateGoalUseCase.execute(requestValue: $0)
            }

        return Output(categoryBinding: categoryBinding,
                      oneLineMindBinding: oneLineMindBinding,
                      priceBinding: priceBinding,
                      isPublicBinding: isPublicBinding,
                      ctaButtonActivate: canMoveNext, generateGoalStatusCode: generateGoalStatusCode)
    }
}

