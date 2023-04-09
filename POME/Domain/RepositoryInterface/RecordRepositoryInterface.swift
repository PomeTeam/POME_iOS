//
//  RecordRepositoryInterface.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

protocol RecordRepositoryInterface{
    func getRecordInReview(goalId: Int, requestValue: GetRecordInReviewRequestModel) -> Observable<PageableResponseModel<RecordResponseModel>>
    func modifyRecord(id: Int, requestValue: RecordDTO) -> Observable<RecordResponseModel>
    func generateRecord(requestValue: GenerateRecordRequestModel) -> Observable<Int>
    func deleteRecord(requestValue: DeleteRecordRequestModel) -> Observable<BaseResponseStaus>
}
