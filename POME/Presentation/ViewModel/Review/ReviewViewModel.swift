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
    private let getRecordsUseCase: GetRecordInReviewUseCaseInterface
    private let deleteRecordUseCase: GetGoalUseCaseInterface
    
    init(regardlessOfRecordCount: Int,
         getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         getRecordsUseCase: GetRecordInReviewUseCaseInterface = GetRecordInReviewUseCase(),
         deleteRecordUseCase: GetGoalUseCaseInterface = GetGoalUseCase()){
        self.regardlessOfRecordCount = regardlessOfRecordCount
        self.getGoalsUseCase = getGoalsUseCase
        self.getRecordsUseCase = getRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    private typealias FilteringCondition = (first: Int?, second: Int?)
    
    private var page = 0
    private var goals = [GoalResponseModel]()
    private var records = [RecordResponseModel]()
    private lazy var dataIndex: (Int) -> Int = { row in row - self.regardlessOfRecordCount }
    
    private let disposeBag = DisposeBag()
    private let selectGoalSubject = BehaviorSubject<Int>(value: 0)
    private let filteringConditionSubject = BehaviorSubject<FilteringCondition>(value: (nil, nil))
    
    struct Input{
        
    }
    
    struct Output{
        let firstEmotionState: Driver<EmotionTag>
        let secondEmotionState: Driver<EmotionTag>
        let initializeEmotionFilter: Driver<Void>
        let reloadTableView: Driver<Void>
        let showEmptyView: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output{
        
        let recordRequestObservable = Observable.combineLatest(selectGoalSubject, filteringConditionSubject)
        
        let recordsResponse = recordRequestObservable
            .skip(1)
            .do(onNext: { _ in
                self.page = 0
            }).flatMap{ _, filtering in
                self.getRecordsUseCase.execute(goalId: self.selectedGoal.id,
                                               requestValue: GetRecordInReviewRequestModel(firstEmotion: filtering.first,
                                                                                           secondEmotion: filtering.second,
                                                                                           pageable: PageableModel(page: self.page)))
            }
        
        let reloadTableView = recordsResponse
            .map{ _ in Void() }
            .asDriver(onErrorJustReturn: Void())
        
        let showEmptyView = recordsResponse
            .map{ $0.content.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        
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
                      initializeEmotionFilter: initializeEmotionFilter,
                      reloadTableView: reloadTableView,
                      showEmptyView: showEmptyView)
    }
    
    
}

extension ReviewViewModel{
    
    func viewDidLoad(){
        getGoalsUseCase.execute()
            .subscribe(onNext: { [weak self] in
                self?.responseGetGoals(goals: $0)
            }).disposed(by: disposeBag)
    }
    
    private func responseGetGoals(goals: [GoalResponseModel]){
        self.goals = goals.filter{ !$0.isEnd }
        selectGoalSubject.onNext(selectedGoalIndex)
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
        goals.count
    }
    
    var recordsCount: Int{
        records.count
    }
    
    func getRecord(at index: Int) -> RecordResponseModel{
        records[dataIndex(index)]
    }
    
    func getGoal(at index: Int) -> GoalResponseModel{
        goals[index]
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
