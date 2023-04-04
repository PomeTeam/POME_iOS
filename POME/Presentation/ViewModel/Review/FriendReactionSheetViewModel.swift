//
//  FriendReactionSheetViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation
import RxSwift
import RxCocoa

class FriendReactionSheetViewModel: BaseViewModel{
    
    private lazy var filteringReactions: [FriendReactionResponseModel] = allReactions
    private let allReactions: [FriendReactionResponseModel]
    
    init(allReactions: [FriendReactionResponseModel]){
        self.allReactions = allReactions
    }
    
    private let ALL_REACTION = 0 // 전체인 경우 식별하기 위해 선언한 리터럴 값
    private let disposeBag = DisposeBag()
    private let selectReactionSubject = BehaviorSubject(value: 0)
    
    struct Input { }
    
    struct Output {
        let selectReactionCount: Driver<Int>
        let tableViewReload: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let selectReactionCount = selectReactionSubject
            .map{ reactionId in
                if(reactionId == self.ALL_REACTION){
                    return self.allReactions
                }
                return self.filteringReactions(id: reactionId)
            }.do{
                self.filteringReactions = $0
            }.map{
                $0.count
            }.asDriver(onErrorJustReturn: 0)
        
        let tableViewWillReload = selectReactionSubject
            .map{ _ in true }
            .asDriver(onErrorJustReturn: false)
        
        return Output(selectReactionCount: selectReactionCount,
                      tableViewReload: tableViewWillReload)
    }
    
    private func filteringReactions(id: Int) -> [FriendReactionResponseModel]{
        let bindingId = id - 1
        return allReactions.filter{ $0.emotionId == bindingId }
    }
}

extension FriendReactionSheetViewModel{
    
    func selectedReaction() -> Int{
        try! selectReactionSubject.value()
    }
    
    func selectReaction(id: Int){
        selectReactionSubject.onNext(id)
    }
    
    func getFriendReaction(at index: Int) -> FriendReactionResponseModel{
        filteringReactions[index]
    }
    
    func getFriendsReactionCount() -> Int{
        filteringReactions.count
    }
}
