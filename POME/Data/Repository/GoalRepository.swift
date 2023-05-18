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

    func generateGoal(requestValue: GenerateGoalRequestModel) -> Observable<GenerateGoalStatus> {
        let observable = Observable<GenerateGoalStatus>.create { observer -> Disposable in
            let requestReference: () = GoalService.shared.generateGoal(request: requestValue){ response in
                switch response {
                case .success:
                    observer.onNext(GenerateGoalStatus.success)
                case .invalidSuccess(let code, let message):
                    if let error = GenerateGoalStatus(rawValue: code){
                        observer.onNext(error)
                    }
                    print(message)
                default:
                    break
                }
            }
            return Disposables.create(with: { requestReference })
        }
        return observable
    }
    
    func deleteGoal() {
        
    }
}
