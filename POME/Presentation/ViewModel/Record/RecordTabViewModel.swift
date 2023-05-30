//
//  RecordTabViewModel.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift
import RxCocoa

/*
 목표 리스트 조회
 목표 삭제
 목표에 해당하는 기록 조회
 기록 삭제
 일주일이 지났고 두번째 감정이 필요한 기록 조회
 */

protocol NoSecondEmotionViewModelInterface {
    var noSecondEmotionRecords: Int { get }
}

protocol RecordTabViewModelInterface: BaseViewModel, ModifyRecordInterface {
    var goals: [GoalResponseModel] { get }
    var records: [RecordResponseModel] { get }
}

final class RecordTabViewModel: ReviewViewModelInterface, NoSecondEmotionViewModelInterface {
    
    var goals = [GoalResponseModel]()
    var records = [RecordResponseModel]()
    var noSecondEmotionRecords: Int = 0
    
    private var page: Int = 0
    private var selectedGoalIndex: Int = 0
    var hasNextPage: Bool = false
    
    let changeGoalSelect = PublishSubject<Void>()
    let reloadTableView = PublishRelay<Void>()
    let deleteGoalSubject = PublishSubject<Void>()
    let deleteRecordSubject = PublishSubject<Int>()
    let modifyRecordSubject = PublishSubject<Int>()
    
    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let deleteGoalUseCase: DeleteGoalUseCaseInterface
    private let getRecordsOfGoalInRecordTabUseCase: GetRecordsOfGoalInRecordTabUseCaseInterface
    private let deleteRecordUseCase: DeleteRecordUseCaseInterface
    private let getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface
    
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        let selectedGoalIndex: Observable<Int>
    }
    
    struct Output{
        
    }
    
    init(getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         deleteGoalUseCase: DeleteGoalUseCaseInterface = DeleteGoalUseCase(),
         getRecordsOfGoalInRecordTabUseCase: GetRecordsOfGoalInRecordTabUseCaseInterface = GetRecordsOfGoalInRecordTabUseCase(),
         deleteRecordUseCase: DeleteRecordUseCaseInterface = DeleteRecordUseCase(),
         getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface = GetNoSecondEmotionRecordsUseCase()) {
        
        self.getGoalsUseCase = getGoalsUseCase
        self.deleteGoalUseCase = deleteGoalUseCase
        self.getRecordsOfGoalInRecordTabUseCase = getRecordsOfGoalInRecordTabUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
        self.getNoSecondEmotionRecordsUseCase = getNoSecondEmotionRecordsUseCase
    }
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
//        let getGoalsResponse = getGoalsUseCase.execute()
            
        input.selectedGoalIndex
            .subscribe{ [weak self] in
                self?.selectedGoalIndex = $0
                self?.initializeStateAndRequestRecord()
            }.disposed(by: disposeBag)
        
        
        return Output()
    }
    
    func deleteGoal() {
        let deleteGoalResponse = deleteGoalUseCase.execute(id: self.goals[selectedGoalIndex].id)
            .subscribe{ [weak self] in
                if $0 == .success {
                    self?.goals.remove(at: self?.selectedGoalIndex ?? 0)
                    self?.deleteGoalSubject.onNext(Void())
                    self?.changeGoalSelect.onNext(Void())
                }
            }
    }
    func deleteRecord(index: Int) {
        deleteRecordUseCase.execute(requestValue: DeleteRecordRequestModel(recordId: records[index].id))
            .subscribe{ [weak self] in
                if $0 == .success {
                    self?.records.remove(at: index)
                    self?.deleteRecordSubject.onNext(index)
                }
            }.disposed(by: disposeBag)
    }
    
    func modifyRecord(_ record: RecordResponseModel, index: Int){
        records[index] = record
        modifyRecordSubject.onNext(index)
    }
    
}

extension RecordTabViewModel {
    func refreshData(){
        getGoalsUseCase.execute()
            .subscribe(onNext: { [weak self] goals in
                self?.goals = goals.filter{ !$0.isEnd }
                self?.initializeStateAndRequestRecord()
            }).disposed(by: disposeBag)
    }
    
    private func initializeStateAndRequestRecord(){
        hasNextPage = false
        page = 0
        canRequestRecord()
    }
    
    private func canRequestRecord(){
        //goal이 존재할 때만 기록 조회 요청
        if goals.isEmpty {
            records = []
            reloadTableView.accept(Void())
        } else if selectedGoalIndex >= goals.count { //현재 선택 중인 목표가 삭제되었을 경우, 목표 변경 VC으로 전달
            changeGoalSelect.onNext(Void())
        } else {
            requestRecords()
            requestNoSecondEmotionRecords()
        }
    }
    
    private func requestRecords(){
        let recordResponse = getRecordsOfGoalInRecordTabUseCase
            .execute(id: goals[self.selectedGoalIndex].id, pageable: PageableModel(page: page))
            .share()
        
        
        recordResponse
            .do(onNext: {
                self.hasNextPage = !$0.last
            }).subscribe(onNext: { [weak self] in
                if $0.page == 0 {
                    self?.records = $0.content
                } else {
                    self?.records.append(contentsOf: $0.content)
                }
                self?.reloadTableView.accept(Void())
            }).disposed(by: disposeBag)
    }
    
    private func requestNoSecondEmotionRecords(){
        getNoSecondEmotionRecordsUseCase
            .execute(id: goals[self.selectedGoalIndex].id)
            .subscribe { [weak self] in
                self?.noSecondEmotionRecords = $0.content.count
            }.disposed(by: disposeBag)
    }

}
