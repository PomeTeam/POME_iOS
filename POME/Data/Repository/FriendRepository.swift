//
//  FriendRepository.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

class FriendRepository: FriendRepositoryInterface{
    
    func getFriends() -> Observable<[FriendsResponseModel]> {
        let observable = Observable<[FriendsResponseModel]>.create { observer -> Disposable in
            let requestReference: () = FriendService.shared.getFriends(pageable: PageableModel(page: 0, size: 100)){ response in
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
    
    func registerReaction(requestValue: RegisterReactionRequestValue) -> Observable<RecordResponseModel> {
        let observable = Observable<RecordResponseModel>.create { observer -> Disposable in
            let requestReference: () = FriendService.shared.generateFriendEmotion(id: requestValue.recordId, emotion: requestValue.emotionId) { response in
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
    
    func hideFriendRecord(recordId: Int) -> Observable<BaseResponseStatus> {
        let observable = Observable<BaseResponseStatus>.create { observer -> Disposable in
            let requestReference: () = FriendService.shared.hideFriendRecord(id: recordId) { response in
                switch response {
                case .success:
                    observer.onNext(.success)
                default:
                    observer.onNext(.fail)
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func getAllFriendsRecords(requestModel: PageableModel) -> Observable<PageableResponseModel<RecordResponseModel>> {
        let observable = Observable<PageableResponseModel<RecordResponseModel>>.create { observer -> Disposable in
            let requestReference: () = FriendService.shared.getAllFriendsRecord(pageable: requestModel, animate: true){ response in
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
    
    func getFriendRecords(requestValue: GetFriendRecordsRequestValue) -> Observable<PageableResponseModel<RecordResponseModel>> {
        let observable = Observable<PageableResponseModel<RecordResponseModel>>.create { observer -> Disposable in
            let requestReference: () = FriendService.shared.getFriendRecord(id: requestValue.friendId, pageable: requestValue.pageable, animate: true){ response in
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
    
}
