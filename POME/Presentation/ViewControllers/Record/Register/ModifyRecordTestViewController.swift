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
    
//    init(record: RecordResponseModel){
//        self.record = record
//    }
    
    init(){
        self.record = TestData.testRecordData
        super.init(recordType: .modify,
                   viewModel: RecordableViewModel(defaultGoal: TestData.testGoalData,
                                                  defaultDate: TestData.testRecordData.useDate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        input = RecordableViewModel.Input(consumePrice: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable().startWith(String(record.usePrice)),
                                          consumeComment: mainView.contentTextView.recordTextView.rx.text.orEmpty.asObservable().startWith(record.useComment))
        
        super.bind()
        
        mainView.completeButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.requestModifyRecord()
            }).disposed(by: disposeBag)
    }
}

fileprivate extension RecordableViewModel{
    func requestModifyRecord(){
//        let modifyRecordUseCase: modifyre
    }
}
