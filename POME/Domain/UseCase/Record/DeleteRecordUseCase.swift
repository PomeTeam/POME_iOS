//
//  DeleteRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

struct DeleteRecordRequestModel{
    let recordId: Int
}

protocol DeleteRecordUseCaseInterface {
    func execute(requestValue: DeleteRecordRequestModel) -> Observable<BaseResponseStaus>
}

final class DeleteRecordUseCase: DeleteRecordUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(requestValue: DeleteRecordRequestModel) -> Observable<BaseResponseStaus> {
        return recordRepository.deleteRecord(requestValue: requestValue)
        
    }
}
