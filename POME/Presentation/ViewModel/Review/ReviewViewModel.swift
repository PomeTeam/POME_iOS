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
    
    private var canRequestNextPage = false
    private var goals = [GoalResponseModel]()
    private var records = [RecordResponseModel]()
    private lazy var dataIndex: (Int) -> Int = { row in row - self.regardlessOfRecordCount }
    
    private let disposeBag = DisposeBag()
    private let selectGoalSubject = BehaviorSubject<Int>(value: 0)
    private let pageSubject = BehaviorSubject<Int>(value: 0)
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
        
        selectGoalSubject
            .skip(1)
            .subscribe(onNext: { [weak self] in
                print("<>goal change", $0)
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)
        
        filteringConditionSubject
            .skip(1)
            .subscribe(onNext: { [weak self] in
                print("<>filtering change", $0)
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)
        
        //왜 요청이 2-3번씩 가는 것일까
        let recordsResponse = pageSubject
            .skip(1)
            .do(onNext: {
                print("<>page change", $0)
                if($0 == 0){
                    self.canRequestNextPage = false
                }
            }).map{ page in
                (page, self.filteringCondition)
            }.flatMap{ (page, filtering) in
                self.getRecordsUseCase.execute(goalId: self.selectedGoal.id,
                                               requestValue: GetRecordInReviewRequestModel(firstEmotion: filtering.first,
                                                                                           secondEmotion: filtering.second,
                                                                                           pageable: PageableModel(page: page)))
            }
        
        recordsResponse
            .do(onNext: {
                self.canRequestNextPage = !$0.last
            }).subscribe(onNext: {
                if($0.page == 0){
                    self.records = $0.content
                }else{
                    self.records.append(contentsOf: $0.content)
                }
            }).disposed(by: disposeBag)
        
        let reloadTableView = recordsResponse
            .map{ _ in Void() }
            .asDriver(onErrorJustReturn: Void())
        
        let showEmptyView = recordsResponse
            .map{ $0.page == 0 && $0.content.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        return Output(firstEmotionState: firstEmotionState,
                      secondEmotionState: secondEmotionState,
                      initializeEmotionFilter: initializeEmotionFilter,
                      reloadTableView: reloadTableView,
                      showEmptyView: showEmptyView)
    }
    
    private func initializeRecordRequest(){
        canRequestNextPage = false
        pageSubject.onNext(0)
    }
}

extension ReviewViewModel{
    
    func refreshData(){
        getGoalsUseCase.execute()
            .subscribe(onNext: { [weak self] in
                self?.responseGetGoals(goals: $0)
            }).disposed(by: disposeBag)
    }
    
    private func responseGetGoals(goals: [GoalResponseModel]){
        self.goals = goals.filter{ !$0.isEnd }
        selectGoalSubject.onNext(selectedGoalIndex)
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
        pageSubject.onNext(try! pageSubject.value() + 1)
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
        canRequestNextPage
    }
}
