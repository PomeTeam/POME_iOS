//
//  RecordObserver.swift
//  POME
//
//  Created by 박소윤 on 2023/05/18.
//

import Foundation
import RxSwift

class RecordObserver{
    
    static let shared = RecordObserver()
    
    private init(){ }
    
    let deleteRecord = PublishSubject<Void>()
    let generateRecord = PublishSubject<Void>()
    let registerSecondEmotion = PublishSubject<Void>()
}
