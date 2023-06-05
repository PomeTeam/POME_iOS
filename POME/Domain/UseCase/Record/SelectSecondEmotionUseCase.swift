//
//  SelectSecondEmotionUseCase.swift
//  POME
//
//  Created by gomin on 2023/06/05.
//

import Foundation
import RxSwift

protocol PostSecondEmotionUseCaseInterface {
    func execute(recordId: Int, requestValue: RecordSecondEmotionRequestModel) -> Observable<BaseResponseStatus>
}

final class PostSecondEmotionUseCase: PostSecondEmotionUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(recordId: Int, requestValue: RecordSecondEmotionRequestModel) -> Observable<BaseResponseStatus>{
        return recordRepository.postSecondEmotion(id: recordId, requestValue: requestValue)
    }
}
