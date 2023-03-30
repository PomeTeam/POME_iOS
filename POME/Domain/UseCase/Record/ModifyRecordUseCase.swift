//
//  ModifyRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

struct ModifyRecordRequestValue{
    let id: Int
    let recordInfo: RecordDTO
}

protocol ModifyRecordUseCaseInterface {
    func execute(requestValue: ModifyRecordRequestValue) -> Observable<Int>
}

final class ModifyRecordUseCase: ModifyRecordUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(requestValue: ModifyRecordRequestValue) -> Observable<Int>{
        return recordRepository.modifyRecord(requestValue: requestValue)
    }
}
