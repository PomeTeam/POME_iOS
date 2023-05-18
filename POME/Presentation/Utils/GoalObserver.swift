//
//  GoalObserver.swift
//  POME
//
//  Created by 박소윤 on 2023/05/18.
//

import Foundation
import RxSwift

class GoalObserver{
    static let shared = GoalObserver()
    
    private init(){}
    
    let generateGoal = PublishSubject<Void>()
    let deleteGoal = PublishSubject<Void>()
}
