//
//  getNoSecondEmotionRecordsUseCase.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift


protocol GetNoSecondEmotionRecordsUseCaseInterface {
    func execute(id: Int) -> Observable<PageableResponseModel<RecordResponseModel>>
}

final class GetNoSecondEmotionRecordsUseCase: GetNoSecondEmotionRecordsUseCaseInterface {

    private let recordRepository: RecordRepositoryInterface

    init(recordRepository: RecordRepositoryInterface = RecordRepository()) {
        self.recordRepository = recordRepository
    }

    func execute(id: Int) -> Observable<PageableResponseModel<RecordResponseModel>> {
        return recordRepository.getNoSecondEmotionRecords(id: id)
        
    }
}
