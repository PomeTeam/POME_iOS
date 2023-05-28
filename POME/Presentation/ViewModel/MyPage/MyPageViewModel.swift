//
//  MyPageViewModel.swift
//  POME
//
//  Created by gomin on 2023/05/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyPageViewModelInterface: BaseViewModel{
    
    var finishedGoals: [GoalResponseModel] { get }
    var marshmallows: MarshmallowResponseModel { get }
    
}

class MyPageViewModel: MyPageViewModelInterface{
    
    var finishedGoals = [GoalResponseModel]()
    var marshmallows = MarshmallowResponseModel(emotionMarshmelloLv: 0, growthMarshmelloLv: 0, honestMarshmelloLv: 0, recordMarshmelloLv: 0)
    
    private let getFinishedGoalsUseCase: GetFinishedGoalsUseCaseInterface
    private let getMarshmallowsUseCase: GetMarshmallowsUseCaseInterface
    
    init(getFinishedGoalsUseCase: GetFinishedGoalsUseCaseInterface = GetFinishedGoalsUseCase(),
         getMarshmallowsUseCase: GetMarshmallowsUseCaseInterface = GetMarshmallowsUseCase()) {
        self.getFinishedGoalsUseCase = getFinishedGoalsUseCase
        self.getMarshmallowsUseCase = getMarshmallowsUseCase
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        
    }
    
    struct Output{
        let goals: Observable<Int>
        let marshmallows: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let finishedGoalsResponse = self.getFinishedGoalsUseCase.execute()
        let marshmallowResponse = self.getMarshmallowsUseCase.execute()
        
        let finishedGoalsTableView = finishedGoalsResponse
            .do{
                self.finishedGoals = $0
            }.map{
                $0.count
            }
        
        let marshmallowTableView = marshmallowResponse
            .do{
                self.marshmallows = $0
            }.map{ _ in
                ()
            }
            
        
        return Output(
            goals: finishedGoalsTableView,
            marshmallows: marshmallowTableView
        )
    }
}
