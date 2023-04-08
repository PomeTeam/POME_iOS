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
    private let selectGoalRelay = BehaviorRelay<Int>(value: 0)
    private let pageRelay = BehaviorRelay<Int>(value: 0)
    private let filteringConditionRelay = BehaviorRelay<FilteringCondition>(value: (nil, nil))
    
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
        
        //emotion filter control
        let firstEmotionState = filteringConditionRelay
            .compactMap{ $0.first }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let secondEmotionState = filteringConditionRelay
            .compactMap{ $0.second }
            .map{
                EmotionTag(rawValue: $0)
            }.compactMap{ $0 }
            .asDriver(onErrorJustReturn: .default)
        
        let initializeEmotionFilter = filteringConditionRelay
            .filter{ $0.first == nil && $0.second == nil}
            .map{ _ in Void() }
            .asDriver(onErrorJustReturn: Void())
        
        //새로운 목표 선택 또는 필터 조건 변경시 paging 관련 프로퍼티 초기화
        selectGoalRelay
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)
        
        filteringConditionRelay
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)

        //기록 조회
        let recordsResponse = pageRelay
            .skip(1)
            .do(onNext: {
                if($0 == 0){
                    self.canRequestNextPage = false
                }
            }).map{ page in
                return (page, self.filteringCondition)
            }.flatMap{ (page, filtering) in
                self.getRecordsUseCase.execute(goalId: self.selectedGoal.id,
                                               requestValue: GetRecordInReviewRequestModel(firstEmotion: filtering.first,
                                                                                           secondEmotion: filtering.second,
                                                                                           pageable: PageableModel(page: page)))
            }.share()
        
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
        pageRelay.accept(0)
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
        selectGoalRelay.accept(selectedGoalIndex)
    }

    func selectGoal(at index: Int){
        selectGoalRelay.accept(index)
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
        filteringConditionRelay.value
    }
    
    private func changeFilteringCondition(first: Int?, second: Int?){
        filteringConditionRelay.accept((first, second))
    }
    
    func requestNextPage(){
        pageRelay.accept(pageRelay.value + 1)
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
        selectGoalRelay.value
    }
    
    func hasNextPage() -> Bool{
        canRequestNextPage
    }
}
