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

protocol NoSecondEmotionRecordCountViewModelInterface {
    var noSecondEmotionRecordsCount: Int { get }
}

//protocol RecordTabViewModelInterface: BaseViewModel, ModifyRecordInterface {
//    var goals: [GoalResponseModel] { get }
//    var records: [RecordResponseModel] { get }
//}

final class RecordTabViewModel: GoalWithRecordViewModel, NoSecondEmotionRecordCountViewModelInterface {
    
    internal var noSecondEmotionRecordsCount: Int = 0

    private let deleteGoalUseCase: DeleteGoalUseCaseInterface
    private let getRecordsUseCase: GetRecordsOfGoalInRecordTabUseCaseInterface
    private let getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface

    
    init(deleteGoalUseCase: DeleteGoalUseCaseInterface = DeleteGoalUseCase(),
         getRecordsOfGoalInRecordTabUseCase: GetRecordsOfGoalInRecordTabUseCaseInterface = GetRecordsOfGoalInRecordTabUseCase(),
         getNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface = GetNoSecondEmotionRecordsUseCase()) {
        
        self.deleteGoalUseCase = deleteGoalUseCase
        self.getRecordsUseCase = getRecordsOfGoalInRecordTabUseCase
        self.getNoSecondEmotionRecordsUseCase = getNoSecondEmotionRecordsUseCase
    }
    
    func deleteGoal() {
        let deleteGoalResponse = deleteGoalUseCase.execute(id: self.goals[selectedGoalIndex].id)
            .subscribe{ [weak self] in
                if $0 == .success {
                    self?.goals.remove(at: self?.selectedGoalIndex ?? 0)
                    self?.changeGoalSelect.onNext(Void())
                }
            }
    }
    
    override func requestRecords(){
        requestNoSecondEmotionRecords()
        
        let recordResponse = getRecordsUseCase
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
                self?.noSecondEmotionRecordsCount = $0.content.count
            }.disposed(by: disposeBag)
    }
    
}
