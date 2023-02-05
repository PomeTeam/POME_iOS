//
//  RecordModifyContentViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/05.
//

import Foundation

class RecordModifyContentViewController: RecordRegisterContentViewController{
    
    let goal: GoalResponseModel
    let record: RecordResponseModel!
    
    init(goal: GoalResponseModel, record: RecordResponseModel){
        self.goal = goal
        self.record = record
        super.init(mainView: RecordContentView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordManager.initialize()
        recordManager.bind(goalId: goal.id, record: record)
        addKeyboardNotifications()
    }
    
    override func style() {
        super.style()
        mainView.completeButton.setTitle("수정했어요", for: .normal)
    }
    
    override func initialize() {
        super.initialize()
        bindingData()
    }
    
    //TODO: TextView placeholder 색상말고 텍스트 색상으로 띄우기
    private func bindingData(){
        mainView.dateField.infoTextField.text = record.useDate
        mainView.priceField.infoTextField.text = String(record.usePrice)
        mainView.contentTextView.recordTextView.text = record.useComment
        mainView.goalField.infoTextField.text = goal.goalNameBinding
    }
    
    override func completeButtonDidClicked() {
        requestModifyRecord()
    }
}

//MARK: - API

extension RecordModifyContentViewController{
    
    private func requestModifyRecord(){
        
        guard let price = Int(recordManager.price) else { return }
        let request = RecordRegisterRequestModel(goalId: recordManager.goalId,
                                                 emotionId: recordManager.emotion,
                                                 usePrice: price,
                                                 useDate: recordManager.consumeDate,
                                                 useComment: recordManager.detail)
        
        print(request)
        
        RecordService.shared.modifyRecord(id: recordManager.recordId,
                                          request: request){ response in
            switch response{
            case .success:
                self.navigationController?.popToRootViewController(animated: true)
                break
            default:
                break
            }
            
        }
    }
}

