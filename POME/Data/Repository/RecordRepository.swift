//
//  RecordRepository.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

class RecordRepository: RecordRepositoryInterface{
    
    func modifyRecord(id: Int, requestValue: RecordDTO) -> Observable<Int> {
        let observable = Observable<Int>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.modifyRecord(id: id, request: requestValue){ response in
                switch response {
                case .success:
                    observer.onNext(200)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func generateRecord(requestValue: GenerateRecordRequestModel) -> Observable<Int>{
        let observable = Observable<Int>.create { observer -> Disposable in
            let requestReference: () = RecordService.shared.generateRecord(request: requestValue){ response in
                switch response {
                case .success:
                    observer.onNext(200)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }

    func deleteRecord() {

    }
}
