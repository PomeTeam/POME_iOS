//
//  SelectSecondEmotionViewModel.swift
//  POME
//
//  Created by gomin on 2023/06/05.
//

import RxSwift
import RxCocoa
import RxGesture


final class PostSecondEmotionViewModel: SelectEmotionViewModel {
    
    private let postSecondEmotionUseCase: PostSecondEmotionUseCase
    
    init(postSecondEmotionUseCase: PostSecondEmotionUseCase = PostSecondEmotionUseCase()){
        self.postSecondEmotionUseCase = postSecondEmotionUseCase
    }
    
    override func register(_ input: SelectEmotionViewModel.SecondInput, _ selectEmotion: Driver<Int>) -> Driver<BaseResponseStatus> {
        let registerStatusCode = input.ctaButtonTap
                    .withLatestFrom(selectEmotion)
                    .compactMap{
                        EmotionTag(tagValue: $0)?.rawValue
                    }.map{ emotion in
                        RecordSecondEmotionRequestModel(emotionId: emotion)
                    }.flatMap{
                        self.postSecondEmotionUseCase.execute(recordId: input.record, requestValue: $0)
                    }.asDriver(onErrorJustReturn: BaseResponseStatus.fail)
        
        return registerStatusCode
    }
}
