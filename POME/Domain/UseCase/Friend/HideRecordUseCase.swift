//
//  HideRecordUseCase.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift

protocol HideRecordUseCaseInterface {
    func execute(recordId: Int) -> Observable<BaseResponseStatus>
}

final class HideRecordUseCase: HideRecordUseCaseInterface {

    private let friendRepository: FriendRepositoryInterface

    init(friendRepository: FriendRepositoryInterface = FriendRepository()) {
        self.friendRepository = friendRepository
    }

    func execute(recordId: Int) -> Observable<BaseResponseStatus>{
        return friendRepository.hideFriendRecord(recordId: recordId)
    }
}
