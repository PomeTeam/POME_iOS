//
//  ModifyRecordTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

final class ModifyRecordViewController: Recordable{
    
    var completion: ((RecordResponseModel) -> Void)? //ViewModel 활용안하는 VC에게 데이터 전달 용도
    
    private let record: RecordResponseModel
    private var modifyViewModel: (any GoalWithRecordViewModelInterface)?
    private var index: Int!
    private var tableViewIndexPath: IndexPath!
    
    init(modifyViewModel: any GoalWithRecordViewModelInterface, index: Int, goal: GoalResponseModel){
        self.modifyViewModel = modifyViewModel
        self.index = index
        self.record = modifyViewModel.records[index]
        super.init(recordType: .modify, viewModel: ModifyRecordViewModel(recordId: record.id,
                                                                         defaultGoal: goal,
                                                                         defaultDate: record.useDate))
    }
    //will delete
    init(goal: GoalResponseModel, record: RecordResponseModel){
        self.record = record
        super.init(recordType: .modify,
                   viewModel: ModifyRecordViewModel(recordId: record.id,
                                                    defaultGoal: goal,
                                                    defaultDate: record.useDate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        guard let viewModel = viewModel as? ModifyRecordViewModel else { return }
        
        input = RecordableViewModel.Input(consumePrice: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable().startWith(String(record.usePrice)),
                                          consumeComment: mainView.contentTextView.textView.rx.text.orEmpty.asObservable().startWith(record.useComment))
        
        super.bind()
        
        viewModel.controlEvent(mainView.completeButton.rx.tap)
            .subscribe(onNext: { modifyRecord in
                self.modifyViewModel?.modifyRecord(modifyRecord, index: self.index)
                self.completion?(modifyRecord)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
