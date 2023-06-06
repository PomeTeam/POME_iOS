//
//  NoSecondEmotionRecordViewModel.swift
//  POME
//
//  Created by gomin on 2023/05/31.
//

import Foundation
import RxSwift
import RxCocoa

/*
 일주일이 지났고 두번째 감정이 필요한 기록 조회
 기록 삭제
 기록 수정
 */

protocol RecordSecondEmotionViewModelInterface: BaseViewModel, ModifyRecordInterface {
    var records: [RecordResponseModel] { get }
}


final class RecordSecondEmotionViewModel: RecordSecondEmotionViewModelInterface, DeleteRecord {
    
    private let deleteRecordUseCase: DeleteRecordUseCaseInterface
    private let getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface
    
    init(getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface = GetNoSecondEmotionRecordsUseCase(),
         deleteRecordUseCase: DeleteRecordUseCaseInterface = DeleteRecordUseCase()) {
        self.getNoSecondEmotionRecordsUseCase = getNoSecondEmotionRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }

    var hasNextPage: Bool = false
    var page: Int = 0
    
    var goal = GoalResponseModel(endDate: "", id: 0, isEnd: true, isPublic: true, name: "", nickname: "", oneLineMind: "", price: 0, startDate: "", usePrice: 0)
    internal var records = [RecordResponseModel]()
    
    let reloadTableView = PublishRelay<Void>()
    let deleteRecordSubject = PublishSubject<Int>()
    let modifyRecordSubject = PublishSubject<Int>()
 
    let disposeBag = DisposeBag()
    
    struct Input{
        let goal: Observable<GoalResponseModel>
    }
    
    struct Output{}
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
        input.goal
            .subscribe{ [weak self] in
                self?.goal = $0
                self?.initializeStateAndRequestRecord()
            }.disposed(by: disposeBag)
        
        return Output()
    }
    
    func refreshData() {
        initializeStateAndRequestRecord()
    }
    
    private func initializeStateAndRequestRecord(){
        hasNextPage = false
        page = 0
        requestNoSecondEmotionRecords()
    }
    
    private func requestNoSecondEmotionRecords(){
        getNoSecondEmotionRecordsUseCase
            .execute(id: goal.id)
            .subscribe { [weak self] in
                self?.records = $0.content
                self?.reloadTableView.accept(Void())
            }.disposed(by: disposeBag)
    }
    
}

extension RecordSecondEmotionViewModel {
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
