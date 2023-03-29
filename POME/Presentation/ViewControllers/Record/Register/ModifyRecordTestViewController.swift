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
                   viewModel: ModifyRecordViewModel(defaultGoal: TestData.testGoalData,
                                                    defaultDate: TestData.testRecordData.useDate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        super.bind()
        
        let input = RecordableViewModel.Input(consumePrice: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable().startWith(String(record.usePrice)),
                                                consumeComment: mainView.contentTextView.recordTextView.rx.text.orEmpty.asObservable().startWith(record.useComment))
        
        let output = viewModel.transform(input)
        
        output.goalBinding
            .drive{ [weak self] in
                self?.mainView.goalField.infoTextField.text = $0
            }.disposed(by: disposeBag)
        
        output.dateBinding
            .drive{ [weak self] in
                self?.mainView.dateField.infoTextField.text = $0
            }.disposed(by: disposeBag)
        
        output.priceBinding
            .drive{ [weak self] in
                self?.mainView.priceField.infoTextField.text = $0
            }.disposed(by: disposeBag)
        
        output.commentBinding
            .drive{ [weak self] in
                self?.mainView.contentTextView.recordTextView.text = $0
            }.disposed(by: disposeBag)
        
        output.highlightCalendarIcon
            .drive(mainView.dateField.rightImage.rx.isHighlighted)
            .disposed(by: disposeBag)
        
        output.canMoveNext
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
    }
}
