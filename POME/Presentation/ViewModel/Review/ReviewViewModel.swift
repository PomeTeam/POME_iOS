//
//  ReviewViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa


/*
 Review
 
 1. Modify
 2. Delete >
 3. Reaction 조회 >
 4. 목표 조회 > ViewController에서 데이터 관리
 5. 기록 필터링 > ViewController에서 데이터 관리
 */

protocol ModifyRecordInterface{
    var modifyRecordCompleted: ((_ index: Int) -> Void)! { get }
    func modifyRecord(index: Int)
}

protocol DeleteRecord{
    var deleteRecordCompleted: ((Int) -> Void)! { get }
    func deleteRecord(index: Int)
}

protocol PageableInterface{
    var hasNextPage: Bool { get }
}

protocol ReviewViewModelInterface: BaseViewModel{
    var goals: [GoalResponseModel] { get }
    var records: [RecordResponseModel] { get }
}

class ReviewViewModel: ReviewViewModelInterface, ModifyRecord{
    
    func getRecord(at: Int) -> RecordResponseModel {
        records[at]
    }
    

    private let regardlessOfRecordCount: Int
    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let getRecordsUseCase: GetRecordInReviewUseCaseInterface
    private let deleteRecordUseCase: DeleteRecordUseCaseInterface
    
    init(regardlessOfRecordCount: Int,
         getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         getRecordsUseCase: GetRecordInReviewUseCaseInterface = GetRecordInReviewUseCase(),
         deleteRecordUseCase: DeleteRecordUseCaseInterface = DeleteRecordUseCase()){
        self.regardlessOfRecordCount = regardlessOfRecordCount
        self.getGoalsUseCase = getGoalsUseCase
        self.getRecordsUseCase = getRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    var hasNextPage: Bool = false
    var goals = [GoalResponseModel]()
    var records = [RecordResponseModel]()

    private lazy var dataIndex: (Int) -> Int = { row in row - self.regardlessOfRecordCount }
    
    private let disposeBag = DisposeBag()
    private let modifyRecordSubject = PublishSubject<IndexPath>()
    private let deleteRecordSubject = PublishSubject<IndexPath>()
    private let selectGoalRelay = BehaviorRelay<Int>(value: 0)
    private let pageRelay = BehaviorRelay<Int>(value: 0)
    private let emptyViewVisibilitySubject = PublishSubject<Bool>()
    private var emotionFilter: Review.EmotionFiltering = (nil, nil)
    
    
    struct Input{
        let filteringEmotion: Observable<Review.EmotionFiltering>
    }
    
    struct Output{
        let deleteRecord: Driver<IndexPath>
        let modifyRecord: Driver<IndexPath>
        let reloadTableView: Driver<Void>
        let showEmptyView: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output{
        
        //deleteRecord
        let deleteResponse = deleteRecordSubject
            .map{ self.records[self.dataIndex($0.row)].id }
            .flatMap{
                self.deleteRecordUseCase.execute(requestValue: DeleteRecordRequestModel(recordId: $0))
            }.share()
        
        let deleteIndexPath = Observable.zip(deleteResponse, deleteRecordSubject)
            .filter{ $0.0 == .success }
            .do(onNext: {
                self.records.remove(at: self.dataIndex($1.row))
            })
            .map{ $0.1 }
            .asDriver(onErrorJustReturn: IndexPath.init())
        
        //modify record
        let modifyRecordIndexPath = modifyRecordSubject
            .asDriver(onErrorJustReturn: IndexPath.init())
        
        //새로운 목표 선택 또는 필터 조건 변경시 paging 관련 프로퍼티 초기화
        selectGoalRelay
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)
        
        input.filteringEmotion
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.emotionFilter = $0
                self?.initializeRecordRequest()
            }).disposed(by: disposeBag)

        //기록 조회
        let recordsResponse = pageRelay
            .skip(1)
            .do(onNext: {
                if($0 == 0){
                    self.hasNextPage = false
                }
            }).map{ page in
                return (page, self.emotionFilter)
            }
            .flatMap{ page, filtering in
                self.getRecordsUseCase.execute(goalId: self.selectedGoal.id,
                                               requestValue: GetRecordInReviewRequestModel(firstEmotion: filtering.first,
                                                                                           secondEmotion: filtering.second,
                                                                                           pageable: PageableModel(page: page)))
            }.share()
        
        recordsResponse
            .do(onNext: {
                self.hasNextPage = !$0.last
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
        
        let showEmptyView = emptyViewVisibilitySubject
            .asDriver(onErrorJustReturn: false)
        
        
        return Output(
            deleteRecord: deleteIndexPath,
            modifyRecord: modifyRecordIndexPath,
            reloadTableView: reloadTableView,
            showEmptyView: showEmptyView
        )
    }
    
    private func initializeRecordRequest(){
        hasNextPage = false
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
    
    func modifyRecord(indexPath: IndexPath, _ record: RecordResponseModel){
        records[dataIndex(indexPath.row)] = record
        modifyRecordSubject.onNext(indexPath)
    }
    
    func deleteRecord(at indexPath: IndexPath){
        deleteRecordSubject.onNext(indexPath)
    }

    func selectGoal(at index: Int){
        selectGoalRelay.accept(index)
    }
    
    func requestNextPage(){
        pageRelay.accept(pageRelay.value + 1)
    }
    
    var selectedGoal: GoalResponseModel{
        goals[selectedGoalIndex]
    }
    
    var selectedGoalIndex: Int{
        selectGoalRelay.value
    }
}
