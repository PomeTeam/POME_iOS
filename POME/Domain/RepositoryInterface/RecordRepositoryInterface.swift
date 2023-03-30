//
//  RecordRepositoryInterface.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol RecordRepositoryInterface{
    func modifyRecord(requestValue: ModifyRecordRequestValue) -> Observable<Int>
    func generateRecord()
    func deleteRecord()
}
