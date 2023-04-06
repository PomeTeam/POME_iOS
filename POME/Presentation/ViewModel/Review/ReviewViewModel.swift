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
    
    private let regardlessOfRecordCount: Int
    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let getRecordsUseCase: GetGoalUseCaseInterface
    private let deleteRecordUseCase: GetGoalUseCaseInterface
    
    init(regardlessOfRecordCount: Int,
         getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         getRecordsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         deleteRecordUseCase: GetGoalUseCaseInterface = GetGoalUseCase()){
        self.regardlessOfRecordCount = regardlessOfRecordCount
        self.getGoalsUseCase = getGoalsUseCase
        self.getRecordsUseCase = getRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    private typealias FilteringCondition = (first: Int?, second: Int?)
    
    private var goals = [GoalResponseModel]()
    private var records = [RecordResponseModel]()
    private lazy var dataIndex: (Int) -> Int = { row in row - self.regardlessOfRecordCount }
    
    private let selectGoalSubject = BehaviorSubject<Int>(value: 0)
    private let filteringConditionSubject = BehaviorSubject<FilteringCondition>(value: (nil, nil))
    
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
            .compactMap{ $0.first }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let secondEmotionState = filteringConditionSubject
            .compactMap{ $0.second }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let initializeEmotionFilter = filteringConditionSubject
            .filter{ $0.first == nil && $0.second == nil}
            .map{ _ in Void() }
            .asDriver(onErrorJustReturn: Void())
        
        return Output(firstEmotionState: firstEmotionState,
                      secondEmotionState: secondEmotionState,
                      initializeEmotionFilter: initializeEmotionFilter)
    }
    
    
}

extension ReviewViewModel{
    
    func viewDidLoad(){
        
    }
    
    func updateData(){
        
    }

    func selectGoal(at index: Int){
        selectGoalSubject.onNext(index)
    }
    
    func filterFirstEmotion(id: Int){
        changeFilteringCondition(first: id, second: filteringCondition.1)
    }
    
    func filterSecondEmotion(id: Int){
        changeFilteringCondition(first: filteringCondition.0, second: id)
    }
    
    func initializeFilterCondtion(){
        changeFilteringCondition(first: nil, second: nil)
    }
    
    private var filteringCondition: FilteringCondition{
        try! filteringConditionSubject.value()
    }
    
    private func changeFilteringCondition(first: Int?, second: Int?){
        filteringConditionSubject.onNext((first, second))
    }
    
    func requestNextPage(){
        
    }
    
    var isGoalEmpty: Bool{
        goals.count == 0
    }
    
    var goalsCount: Int{
        isGoalEmpty ? 1 : goals.count
    }
    
    var recordsCount: Int{
        records.count
    }
    
    func getRecord(at index: Int) -> RecordResponseModel{
        records[dataIndex(index)]
    }
    
    var selectedGoal: GoalResponseModel{
        goals[selectedGoalIndex]
    }
    
    var selectedGoalIndex: Int{
        try! selectGoalSubject.value()
    }
    
    func hasNextPage() -> Bool{
        true
    }
}
