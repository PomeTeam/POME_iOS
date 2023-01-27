//
//  RecordRegisterRequestManager.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation

class RecordRegisterRequestManager{
    
    static let shared = RecordRegisterRequestManager()
    
    var goalId: Int = -1
    var consumeDate: String = PomeDateFormatter.getTodayDate()
    var price: String = ""
    var detail: String = ""
    var emotion: Int = -1
    
    private init() { }
    
    func initialize(){
        goalId = -1
        consumeDate = PomeDateFormatter.getTodayDate()
        price = ""
        detail = ""
        emotion = -1
    }
    
    func info(){
        print(self)
        print("goalId", goalId, "consumeDate", consumeDate, "price", price, "detail", detail)
    }
}
