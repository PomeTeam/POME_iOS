//
//  RecordService.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

final class RecordService{
    static let shared = RecordService()
    private init() { }
    let provider = MultiMoyaService(plugins: [MoyaLoggerPlugin()])
}

extension RecordService{
    
    func modifyRecord(id: Int, request: RecordDTO, completion: @escaping (NetworkResult<RecordResponseModel>) -> Void) {
        provider.requestDecoded(RecordRouter.patchRecord(id: id, request: request), animate: true){ response in
            completion(response)
        }
    }

    func deleteRecord(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.requestNoResultAPI(RecordRouter.deleteRecord(id: id), animate: true){ response in
            completion(response)
        }
    }
    
    func generateRecord(request: GenerateRecordRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.requestNoResultAPI(RecordRouter.postRecord(request: request), animate: true){ response in
            completion(response)
        }
    }
    
//    func getRecordsOfGoal(id: Int, pageable: PageableModel, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
//        requestDecoded(RecordRouter.getRecordsOfGoalByUser(id: id, pageable: pageable)) { response in
//            completion(response)
//        }
//    }
    
    func getRecordsOfGoal(id: Int, pageable: PageableModel, animate: Bool, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        provider.requestDecoded(RecordRouter.getRecordsOfGoalByUser(id: id, pageable: pageable), animate: animate) { response in
            completion(response)
        }
    }
    
    func getRecordsOfGoalAtRecordTab(id: Int, pageable: PageableModel, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        provider.requestDecoded(RecordRouter.getRecordsOfGoalByUserAtRecordTab(id: id, pageable: pageable), animate: true) { response in
            completion(response)
        }
    }
    
//    func getRecordsOfGoalAtReviewTab(id: Int, firstEmotion: Int?, secondEmotion: Int?, pageable: PageableModel, animate: Bool,completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
//        provider.requestDecoded(RecordRouter.getRecordsOfGoalByUserAtReviewTab(id: id, firstEmotion: firstEmotion, secondEmotion: secondEmotion, pageable: pageable), animate: animate) { response in
//            completion(response)
//        }
//    }
    
    //CLEAN ARCHITECURE VER.
    func getRecordsOfGoalAtReviewTab(id: Int, request: GetRecordInReviewRequestModel, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        provider.requestDecoded(RecordRouter.getRecordsOfGoalByUserAtReviewTab(id: id, request: request), animate: false) { response in
            completion(response)
        }
    }
    
    
    func postSecondEmotion(id: Int, param: RecordSecondEmotionRequestModel, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.requestNoResultAPI(RecordRouter.postSecondEmotion(id: id, param: param)){ response in
            completion(response)
        }
    }
    
    func getNoSecondEmotionRecords(id: Int, completion: @escaping (NetworkResult<PageableResponseModel<RecordResponseModel>>) -> Void) {
        print("record service.")
        provider.requestDecoded(RecordRouter.getNoSecondEmoRecords(id: id), animate: true) { response in
            completion(response)
        }
    }
}
