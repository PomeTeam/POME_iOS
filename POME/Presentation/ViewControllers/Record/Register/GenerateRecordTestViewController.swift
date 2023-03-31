//
//  GenerateRecordTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

class GenerateRecordTestViewController: Recordable{
    
    init(goal: GoalResponseModel){
        super.init(recordType: .generate,
                   viewModel: GenerateRecordViewModel(defaultGoal: goal))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        guard let viewModel = viewModel as? GenerateRecordViewModel else { return }
        
        input = RecordableViewModel.Input(consumePrice: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable(),
                                          consumeComment: mainView.contentTextView.recordTextView.rx.text.orEmpty.asObservable())
        
        super.bind()
        
        viewModel.controlEvent(mainView.completeButton.rx.tap)
            .drive(onNext: { [weak self] record in
                if let record = record {
                    self?.navigationController?.pushViewController(RegisterFirstEmotionViewController(record: record), animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
