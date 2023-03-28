//
//  RecordRegisterRequestManager.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation

class RecordRegisterRequestManager{
    
    static let shared = RecordRegisterRequestManager()
    
    var recordId: Int = -1
    var goalId: Int = -1
    var consumeDate: String = PomeDateFormatter.getTodayDate()
    var price: String = "" //int형 변경
    var detail: String = ""
    var emotion: Int = -1
    
    private init() { }
    
    func initialize(){
        recordId = -1
        goalId = -1
        consumeDate = PomeDateFormatter.getTodayDate()
        price = ""
        detail = ""
        emotion = -1
    }
    
    func bind(goalId: Int, record: RecordResponseModel){
        self.recordId = record.id
        self.goalId = goalId
        self.consumeDate = record.useDate
        self.price = String(record.usePrice)
        self.detail = record.useComment
        self.emotion = record.emotionResponse.firstEmotion
    }
}
