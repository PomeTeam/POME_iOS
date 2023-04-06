//
//  ReviewViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewViewModel: BaseViewModel{
    
    private let uiRelatedCellCount: Int
    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let getRecordsUseCase: GetGoalUseCaseInterface
    private let deleteRecordUseCase: GetGoalUseCaseInterface
    
    init(uiRelatedCellCount: Int,
         getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         getRecordsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         deleteRecordUseCase: GetGoalUseCaseInterface = GetGoalUseCase()){
        self.uiRelatedCellCount = uiRelatedCellCount
        self.getGoalsUseCase = getGoalsUseCase
        self.getRecordsUseCase = getRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    private typealias FilteringCondition = (Int?, Int?)
    
    private var selectedGoal: Int!
    private var goals = [GoalResponseModel]()
    private var records = [RecordResponseModel]()
    private lazy var dataIndex: (Int) -> Int = { row in row - self.uiRelatedCellCount }
    
    private let selectGoalSubject = BehaviorSubject<Int>(value: 0)
    private let filteringConditionSubject = BehaviorSubject<(Int?, Int?)>(value: (nil, nil))
    
    struct Input{
        
    }
    
    struct Output{
        let firstEmotionState: Driver<EmotionTag>
        let secondEmotionState: Driver<EmotionTag>
        let initializeEmotionFilter: Driver<Void>
//        let showEmptyView: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output{
        
        let firstEmotionState = filteringConditionSubject
            .compactMap{ $0.0 }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let secondEmotionState = filteringConditionSubject
            .compactMap{ $0.1 }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let initializeEmotionFilter = filteringConditionSubject
            .filter{ $0.0 == nil && $0.1 == nil}
            .map{ _ in Void() }
            .asDriver(onErrorJustReturn: Void())
        
        return Output(firstEmotionState: firstEmotionState,
                      secondEmotionState: secondEmotionState,
                      initializeEmotionFilter: initializeEmotionFilter)
    }
    
    
}

extension ReviewViewModel{
    
    
    /*
     상단에서 아래로 스와이플 할 경우에만 데이터 reload 시키는 건 어떤지..?
     */
    
    func viewDidLoad(){
        
    }

    
    func selectGoal(at index: Int){
        selectGoalSubject.onNext(index)
    }
    
    func filterFirstEmotion(id: Int){
        let current = getCurrentFilteringCondition()
        changeFilteringCondition(first: id, second: current.1)
    }
    
    func filterSecondEmotion(id: Int){
        let current = getCurrentFilteringCondition()
        changeFilteringCondition(first: current.0, second: id)
    }
    
    func initializeFilterCondtion(){
        changeFilteringCondition(first: nil, second: nil)
    }
    
    private func getCurrentFilteringCondition() -> FilteringCondition{
        return try! filteringConditionSubject.value()
    }
    
    private func changeFilteringCondition(first: Int?, second: Int?){
        filteringConditionSubject.onNext((first, second))
    }
    
    func requestNextPage(){
        
    }
    
    func isGoalEmpty() -> Bool{
        goals.count == 0
    }
    
    func getGoalsCount() -> Int{
        goals.count == 0 ? 1 : goals.count
    }
    
    func getRecordsCount() -> Int{
        records.count
    }
    
    func getRecord(at index: Int) -> RecordResponseModel{
        records[dataIndex(index)]
    }
    
    func getSelectGoal() -> GoalResponseModel{
        goals[selectedGoal]
    }
    
    func hasNextPage() -> Bool{
        true
    }
}
