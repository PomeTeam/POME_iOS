//
//  RecordRepositoryInterface.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol RecordRepositoryInterface{
    func modifyRecord(id: Int, requestValue: RecordDTO) -> Observable<Int>
    func generateRecord(requestValue: GenerateRecordRequestModel) -> Observable<Int>
    func deleteRecord()
}
