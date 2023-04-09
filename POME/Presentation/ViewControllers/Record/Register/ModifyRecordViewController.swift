//
//  ModifyRecordTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

protocol ModifyRecord{
    var selectedGoal: GoalResponseModel { get }
    func getRecord(at: Int) -> RecordResponseModel
    func modifyRecord(indexPath: IndexPath, _ record: RecordResponseModel)
}

final class ModifyRecordViewController: Recordable{
    
    private let record: RecordResponseModel
    private var modifyViewModel: ModifyRecord?
    private var tableViewIndexPath: IndexPath!
    
    init(modifyViewModel: ModifyRecord, indexPath: IndexPath){
        self.modifyViewModel = modifyViewModel
        self.tableViewIndexPath = indexPath
        self.record = modifyViewModel.getRecord(at: indexPath.row)
        super.init(recordType: .modify, viewModel: ModifyRecordViewModel(recordId: record.id,
                                                                         defaultGoal: modifyViewModel.selectedGoal,
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
                self.modifyViewModel?.modifyRecord(indexPath: self.tableViewIndexPath, modifyRecord)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
