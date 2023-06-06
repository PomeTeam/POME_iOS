//
//  GenerateRecordTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

final class GenerateRecordViewController: Recordable{
    
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
                                          consumeComment:
                                            mainView.contentTextView.textView.rx.text.orEmpty.asObservable().startWith("소비에 대한 감상을 적어주세요 (150자)"))
        
        super.bind()
        
        viewModel.controlEvent(mainView.completeButton.rx.tap)
            .drive(onNext: { [weak self] record in
                if let record = record {
                    let vc = SelectEmotionViewController(type: .First, record: record)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
