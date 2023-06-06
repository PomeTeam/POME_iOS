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

/*
 SelectEmotionViewModel + generate record
 */

final class RecordFirstEmotionViewModel: SelectEmotionViewModel {
    
    private let generateRecordUseCase: GenerateRecordUseCase
    
    init(generateRecorUseCase: GenerateRecordUseCase = GenerateRecordUseCase()){
        self.generateRecordUseCase = generateRecorUseCase
    }
    
    override func register(_ input: Input, _ selectEmotion: Driver<Int>) -> Driver<BaseResponseStatus> {
        let registerStatusCode = input.ctaButtonTap
                    .withLatestFrom(selectEmotion)
                    .compactMap{
                        EmotionTag(tagValue: $0)?.rawValue
                    }.map{ emotion in
                        GenerateRecordRequestModel(emotionId: emotion,
                                                   goalId: self.record.goalId,
                                                   useComment: self.record.useComment,
                                                   useDate: self.record.useDate,
                                                   usePrice: self.record.usePrice)
                    }.flatMap{
                        self.generateRecordUseCase.execute(requestValue: $0)
                    }.asDriver(onErrorJustReturn: BaseResponseStatus.fail)
        
        return registerStatusCode
    }
    
    
}
