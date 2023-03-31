//
//  RecordRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

enum RecordRouter: BaseRouter{
    case patchRecord(id: Int, request: RecordDTO)
    case deleteRecord(id: Int)
    case postRecord(request: GenerateRecordRequestModel)
    case getRecordsOfGoalByUser(id: Int, pageable: PageableModel)
    case getRecordsOfGoalByUserAtRecordTab(id: Int, pageable: PageableModel)    // 기록탭
    case getRecordsOfGoalByUserAtReviewTab(id: Int, firstEmotion: Int?, secondEmotion: Int?, pageable: PageableModel)    // 회고탭
    case getNoSecondEmoRecords(id: Int)     // 일주일이 지났고, 두 번째 감정을 남겨야하는 기록 조회
    case postSecondEmotion(id: Int, param: RecordSecondEmotionRequestModel)
}

extension RecordRouter{
    
    var path: String {
        switch self {
        case .patchRecord(let id, _):                           return HTTPMethodURL.PUT.record + "/\(id)"
        case .deleteRecord(let id):                             return HTTPMethodURL.DELETE.record + "/\(id)"
        case .postRecord:                                       return HTTPMethodURL.POST.record
        case .getRecordsOfGoalByUser(let id, _):                return HTTPMethodURL.GET.recordOfGoal + "/\(id)"
        case .getRecordsOfGoalByUserAtRecordTab(let id, _):        return HTTPMethodURL.GET.recordOfGoal + "/\(id)/record-tab"
        case .getRecordsOfGoalByUserAtReviewTab(let id, _, _, _):    return HTTPMethodURL.GET.recordOfGoal + "/\(id)/retrospection-tab"
        case .getNoSecondEmoRecords(let id):                    return HTTPMethodURL.GET.noSecondEmotionRecords + "/\(id)"
        case .postSecondEmotion(let id, _):                     return HTTPMethodURL.POST.secondEmotion + "/\(id)" + "/second-emotion"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchRecord:                              return .put
        case .deleteRecord:                             return .delete
        case .postRecord:                               return .post
        case .getRecordsOfGoalByUser:                   return .get
        case .postSecondEmotion:                        return .post
        case .getRecordsOfGoalByUserAtRecordTab:        return .get
        case .getRecordsOfGoalByUserAtReviewTab:        return .get
        case .getNoSecondEmoRecords:                    return .get
        }
    }
    
    var task: Task {
        switch self{
        case .patchRecord(_, let request):                              return .requestJSONEncodable(request)
        case .deleteRecord:                                             return .requestPlain
        case .postRecord(let request):                                  return .requestJSONEncodable(request)
        case .getRecordsOfGoalByUser(_, let pageable),
                .getRecordsOfGoalByUserAtRecordTab(_, let pageable):    return .requestParameters(parameters: ["page" : pageable.page,
                                                                                                               "size" : pageable.size,
                                                                                                               "sort" : pageable.sort],
                                                                                                  encoding: URLEncoding.queryString)
        case .getRecordsOfGoalByUserAtReviewTab(_, let firstEmotion,
                                                let secondEmotion ,
                                                let pageable):
            
            var parameter: [String: Any] = ["page" : pageable.page,
                                            "size" : pageable.size,
                                            "sort" : pageable.sort]
            if(firstEmotion != nil){
                parameter["first_emotion"] = firstEmotion
            }
            if(secondEmotion != nil){
                parameter["second_emotion"] = secondEmotion
            }
                                                                        return .requestParameters(parameters: parameter,
                                                                                                  encoding: URLEncoding.queryString)
        case .getNoSecondEmoRecords:                                    return .requestPlain
        case .postSecondEmotion(_, let param):                          return .requestJSONEncodable(param)
        }
    }
}
