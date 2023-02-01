//
//  RecordService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

final class RecordService: MultiMoyaService{
    static let shared = RecordService()
    private init() { }
}

extension RecordService{
    
    func modifyRecord(id: Int, request: RecordRegisterRequestModel, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(RecordRouter.patchRecord(id: id, request: request)){ response in
            completion(response)
        }
    }
    
    func deleteRecord(id: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(RecordRouter.deleteRecord(id: id)){ response in
            completion(response)
        }
    }
    
    func generateRecord(request: RecordRegisterRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestNoResultAPI(RecordRouter.postRecord(request: request)){ response in
            completion(response)
        }
    }
    
    func getRecordsOfGoal(id: Int, pageable: PageableModel, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        requestDecoded(RecordRouter.getRecordsOfGoalByUser(id: id, pageable: pageable)) { response in
            completion(response)
        }
    }
}
