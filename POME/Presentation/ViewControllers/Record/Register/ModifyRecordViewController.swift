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
            .drive(onNext:{ [weak self] statusCode in
                if(statusCode == 200){
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
