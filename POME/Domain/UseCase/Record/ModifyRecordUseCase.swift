//
//  ModifyRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol ModifyRecordUseCaseInterface {
    func execute(recordId: Int, requestValue: RecordDTO) -> Observable<Int>
}

final class ModifyRecordUseCase: ModifyRecordUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(recordId: Int, requestValue: RecordDTO) -> Observable<Int>{
        return recordRepository.modifyRecord(id: recordId, requestValue: requestValue)
    }
}
