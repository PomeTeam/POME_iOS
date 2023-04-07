//
//  GetRecordInReviewUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

struct GetRecordInReviewRequestModel{
    let firstEmotion: Int?
    let secondEmotion: Int?
    let pageable: PageableModel
}

protocol GetRecordInReviewUseCaseInterface {
    func execute(goalId: Int, requestValue: GetRecordInReviewRequestModel) -> Observable<PageableResponseModel<RecordResponseModel>>
}

final class GetRecordInReviewUseCase: GetRecordInReviewUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(goalId: Int, requestValue: GetRecordInReviewRequestModel) -> Observable<PageableResponseModel<RecordResponseModel>> {
        return recordRepository.getRecordInReview(goalId: goalId, requestValue: requestValue)
        
    }
}
