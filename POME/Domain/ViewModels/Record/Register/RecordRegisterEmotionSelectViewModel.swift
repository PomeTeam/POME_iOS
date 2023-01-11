//
//  RecordRegisterEmotionSelectViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa

class RecordRegisterEmotionSelectViewModel{
    
    private let createRecorUseCase: CreateRecordUseCase
    
    struct Input{
//        let emotionSelect: Observable<>
    }
    
    struct Output{
        let canMoveNext: ControlEvent<Void>
    }
    
    init(createRecordUseCase: CreateRecordUseCase){
        self.createRecorUseCase = createRecordUseCase
    }
    
//    func transform(input: Input) -> Output{
        
//        let canMoveNext
        
//        return Output(canMoveNext: canMoveNext)
//    }
    
    
}
