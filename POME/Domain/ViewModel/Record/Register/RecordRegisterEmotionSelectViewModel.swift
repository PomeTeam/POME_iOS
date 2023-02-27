//
//  RecordRegisterEmotionSelectViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

class RecordRegisterEmotionSelectViewModel{
    
    private let createRecorUseCase: CreateRecordUseCase
    
    struct Input{
        let happyEmotionSelect: TapObservable
        let whatEmotionSelect: TapObservable
        let sadEmotionSelect: TapObservable
        let completeButtonActiveStatus: ControlEvent<Void>
    }
    
    struct Output{
        let canMoveNext: Driver<Bool>
    }
    
    init(createRecordUseCase: CreateRecordUseCase){
        self.createRecorUseCase = createRecordUseCase
    }
    
//    func transform(input: Input) -> Output{
//
//        //TODO: 이모지 하나 tap 했을 때, 버튼 활성화 시키기
//        let canMoveNext = input.happyEmotionSelect
//            .map{
//
//            }
//        return Output(canMoveNext: canMoveNext)
//    }
    
    
}
