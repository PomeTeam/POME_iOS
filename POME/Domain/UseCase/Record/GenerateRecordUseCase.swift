//
//  GenerateRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

struct GenerateRecordRequestModel: Encodable{
    let emotionId: Int
    let goalId: Int
    let useComment: String
    let useDate: String
    let usePrice: Int
}

protocol GenerateRecordUseCaseInterface {
    func execute(requestValue: GenerateRecordRequestModel) -> Observable<BaseResponseStatus>
}

final class GenerateRecordUseCase: GenerateRecordUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(requestValue: GenerateRecordRequestModel) -> Observable<BaseResponseStatus> {
        return recordRepository.generateRecord(requestValue: requestValue)
    }
}
