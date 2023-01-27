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
    var consumeDate: String = ""
    var price: String = ""
    var detail: String = ""
    
    private init() { }
    
    func initialize(){
        goalId = -1
        consumeDate = ""
        price = ""
        detail = ""
    }
}
