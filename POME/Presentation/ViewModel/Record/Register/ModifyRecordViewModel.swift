//
//  ModifyRecordViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

final class ModifyRecordViewModel: RecordableViewModel, RecordButtonControl{
    
    private let modifyRecordUseCase: ModifyRecordUseCaseInterface
    private let recordId: Int
    
    typealias Output = Observable<RecordResponseModel>
    
    init(recordId: Int, defaultGoal: GoalResponseModel, defaultDate: String, modifyRecordUseCase: ModifyRecordUseCaseInterface = ModifyRecordUseCase()) {
        self.recordId = recordId
        self.modifyRecordUseCase = modifyRecordUseCase
        super.init(defaultGoal: defaultGoal, defaultDate: defaultDate)
    }
    
    func controlEvent(_ tapEvent: ControlEvent<Void>) -> Output {
        return tapEvent
            .withLatestFrom(requestObservable)
            .map{ goal, date, price, comment in
                return RecordDTO(goalId: goal.id,
                                 useComment: comment,
                                 useDate: date,
                                 usePrice: price)
            }.flatMap{
                self.modifyRecordUseCase.execute(recordId: self.recordId, requestValue: $0)
            }.asObservable()
    }
    
}
