//
//  GoalRequestManager.swift
//  POME
//
//  Created by 박지윤 on 2023/01/08.
//

import Foundation

//ViewController 전환시 데이터 전달 목적
class GoalRegisterRequestManager{
    
    static let shared = GoalRegisterRequestManager()
    
    var startDate: String = ""
    var endDate: String = ""
    
    private init() { }
}
