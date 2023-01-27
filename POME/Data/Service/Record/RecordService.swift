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
    
    func generateRecord(request: RecordRegisterRequestModel, completion: @escaping (Result<Int, Error>) -> Void) {
        requestNoResultAPI(RecordRouter.postRecord(request: request)){ response in
            completion(response)
        }
    }
}
