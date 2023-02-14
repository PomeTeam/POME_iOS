//
//  RecordModifyContentViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/05.
//

import Foundation

class RecordModifyContentViewController: RecordRegisterContentViewController{
    
    private let goal: GoalResponseModel
    private let record: RecordResponseModel!
    private let completion: (RecordResponseModel) -> Void
    
    init(goal: GoalResponseModel, record: RecordResponseModel, completion: @escaping (RecordResponseModel) -> Void){
        self.goal = goal
        self.record = record
        self.completion = completion
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
    
    override func bindingData(){
        mainView.dateField.infoTextField.text = record.useDate
        mainView.priceField.infoTextField.text = String(record.usePrice)
        mainView.contentTextView.bindingData(record.useComment)
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
            case .success(let data):
                self.completion(data)
                self.navigationController?.popViewController(animated: true)
                break
            default:
                break
            }
            
        }
    }
}

