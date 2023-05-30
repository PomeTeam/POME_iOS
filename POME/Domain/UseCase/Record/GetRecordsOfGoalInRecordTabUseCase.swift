//
//  GetRecordsOfGoalUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift


protocol GetRecordsOfGoalInRecordTabUseCaseInterface {
    func execute(id: Int, pageable: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>>
}

final class GetRecordsOfGoalInRecordTabUseCase: GetRecordsOfGoalInRecordTabUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(id: Int, pageable: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>> {
        return recordRepository.getRecordsOfGoalInRecordTab(id: id, pageable: pageable)
        
    }
}
