//
//  RecordRepository.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

class RecordRepository: RecordRepositoryInterface{
    
    func getRecordInReview(goalId: Int, requestValue: GetRecordInReviewRequestModel) -> Observable<PageableResponseModel<RecordResponseModel>>{
        let observable = Observable<PageableResponseModel<RecordResponseModel>>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.getRecordsOfGoalAtReviewTab(id: goalId, request: requestValue){ response in
                switch response {
                case .success(let data):
                    observer.onNext(data)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func modifyRecord(id: Int, requestValue: RecordDTO) -> Observable<RecordResponseModel> {
        let observable = Observable<RecordResponseModel>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.modifyRecord(id: id, request: requestValue){ response in
                switch response {
                case .success(let data):
                    observer.onNext(data)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func generateRecord(requestValue: GenerateRecordRequestModel) -> Observable<BaseResponseStatus>{
        let observable = Observable<BaseResponseStatus>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.generateRecord(request: requestValue){ response in
                switch response {
                case .success:
                    observer.onNext(.success)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }

    func deleteRecord(requestValue: DeleteRecordRequestModel) -> Observable<BaseResponseStatus>{
        let observable = Observable<BaseResponseStatus>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.deleteRecord(id: requestValue.recordId) { response in
                switch response {
                case .success:
                    observer.onNext(.success)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func getRecordsOfGoalInRecordTab(id: Int, pageable: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>> {
        let observable = Observable<PageableResponseModel<RecordResponseModel>>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.getRecordsOfGoalAtRecordTab(id: id, pageable: pageable) { response in
                switch response {
                case .success(let data):
                    observer.onNext(data)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func getNoSecondEmotionRecords(id: Int) -> Observable<PageableResponseModel<RecordResponseModel>> {
        let observable = Observable<PageableResponseModel<RecordResponseModel>>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.getNoSecondEmotionRecords(id: id) { response in
                switch response {
                case .success(let data):
                    observer.onNext(data)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func postSecondEmotion(id: Int, requestValue: RecordSecondEmotionRequestModel) -> Observable<BaseResponseStatus> {
        let observable = Observable<BaseResponseStatus>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.postSecondEmotion(id: id, param: requestValue) { response in
                switch response {
                case .success:
                    observer.onNext(.success)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
}
