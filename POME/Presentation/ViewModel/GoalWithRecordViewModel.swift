//
//  GoalWithRecordViewModel.swift
//  POME
//
//  Created by gomin on 2023/05/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol ModifyRecordInterface {
    var modifyRecordSubject: PublishSubject<Int> { get }
    func modifyRecord(_ record: RecordResponseModel, index: Int)
}

protocol DeleteRecord{
    var deleteRecordSubject: PublishSubject<Int> { get }
    func deleteRecord(index: Int)
}

protocol PageableInterface{
    var hasNextPage: Bool { get }
}

protocol GoalWithRecordViewModelInterface: BaseViewModel, ModifyRecordInterface {
    var goals: [GoalResponseModel] { get }
    var records: [RecordResponseModel] { get }
}

class GoalWithRecordViewModel: GoalWithRecordViewModelInterface, DeleteRecord{

    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let deleteRecordUseCase: DeleteRecordUseCaseInterface
    
    init(getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         deleteRecordUseCase: DeleteRecordUseCaseInterface = DeleteRecordUseCase()){
        self.getGoalsUseCase = getGoalsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    var hasNextPage: Bool = false
    var goals = [GoalResponseModel]()
    var records = [RecordResponseModel]()
    
    let changeGoalSelect = PublishSubject<Void>()
    let reloadTableView = PublishRelay<Void>()
    let deleteRecordSubject = PublishSubject<Int>()
    let modifyRecordSubject = PublishSubject<Int>()
    
    var page: Int = 0
    var selectedGoalIndex: Int = 0

    let disposeBag = DisposeBag()
    
    struct Input{
        let selectedGoalIndex: Observable<Int>
    }
    
    struct Output{}
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
        input.selectedGoalIndex
            .subscribe{ [weak self] in
                self?.selectedGoalIndex = $0
                self?.initializeStateAndRequestRecord()
            }.disposed(by: disposeBag)
        
        return Output()
    }
    
    func refreshData(){
        getGoalsUseCase.execute()
            .subscribe(onNext: { [weak self] goals in
                self?.goals = goals.filter{ !$0.isEnd }
                self?.initializeStateAndRequestRecord()
            }).disposed(by: disposeBag)
    }
    
    func initializeStateAndRequestRecord(){
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
        }
    }
    
    func requestRecords(){
        
    }

    func requestNextPage(){
        page += 1
        requestRecords()
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
