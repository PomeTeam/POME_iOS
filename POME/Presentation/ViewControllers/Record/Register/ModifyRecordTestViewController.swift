//
//  ModifyRecordTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

struct TestData{
    static let testRecordData = RecordResponseModel(id: 1076, nickname: "쑤야아아아아", usePrice: 1000, useDate: "2023.03.21", createdAt: "2023-03-21T14:17:04.939691", useComment: "반지 샀다ㅎ", oneLineMind: "목표를 달성하자", emotionResponse: EmotionResponseModel(firstEmotion: 0, secondEmotion: nil, friendEmotions: []))
    
    static let testGoalData = GoalResponseModel(endDate: "2023.04.06", id: 1075, isEnd: false, isPublic: true, name: "목표 설정", nickname: "쑤야아아아아", oneLineMind: "목표를 달성하자", price: 100000, startDate: "2023.03.31", usePrice: 1000)
}

class ModifyRecordTestViewController: Recordable{
    
    private let record: RecordResponseModel
    
    init(record: RecordResponseModel){
        self.record = record
        super.init(recordType: .modify,
                   viewModel: ModifyRecordViewModel(recordId: record.id,
                                                    defaultGoal: TestData.testGoalData,
                                                    defaultDate: TestData.testRecordData.useDate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        guard let viewModel = viewModel as? ModifyRecordViewModel else { return }
        
        input = RecordableViewModel.Input(consumePrice: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable().startWith(String(record.usePrice)),
                                          consumeComment: mainView.contentTextView.recordTextView.rx.text.orEmpty.asObservable().startWith(record.useComment))
        
        super.bind()
        
        viewModel.controlEvent(mainView.completeButton.rx.tap)
            .drive(onNext:{ [weak self] statusCode in
                if(statusCode == 200){
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
