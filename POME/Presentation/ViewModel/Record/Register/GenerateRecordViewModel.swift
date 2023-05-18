//
//  GenerateRecordViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/03/30.
//

import Foundation
import RxCocoa

final class GenerateRecordViewModel: RecordableViewModel{
    
    private let generateRecordUseCase: ModifyRecordUseCaseInterface
    
    typealias Output = RecordDTO?
    
    init(defaultGoal: GoalResponseModel, generateRecordUseCase: ModifyRecordUseCaseInterface = ModifyRecordUseCase()) {
        self.generateRecordUseCase = generateRecordUseCase
        super.init(defaultGoal: defaultGoal, defaultDate: PomeDateFormatter.getTodayDate())
    }
    
    func controlEvent(_ tapEvent: ControlEvent<Void>) -> Driver<Output> {
        return tapEvent
            .withLatestFrom(requestObservable)
            .map{ goal, date, price, comment in
                return RecordDTO(goalId: goal.id,
                                 useComment: comment,
                                 useDate: date,
                                 usePrice: price)
            }.asDriver(onErrorJustReturn: nil)
    }
}
