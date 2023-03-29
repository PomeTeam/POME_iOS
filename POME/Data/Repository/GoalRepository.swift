//
//  GoalRepository.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift

class GoalRepository: GoalRepositoryInterface{
    
    func getGoals() -> Observable<[GoalResponseModel]> {
        let observable = Observable<[GoalResponseModel]>.create { observer -> Disposable in
            let requestReference: () = GoalService.shared.getUserGoals { response in
                switch response {
                case .success(let data):
                    observer.onNext(data.content)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }

    func generateGoal() {
        
    }
    
    func deleteGoal() {
        
    }
}
