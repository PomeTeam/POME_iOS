//
//  FriendReactionSheetViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation
import RxSwift

class FriendReactionSheetViewModel: BaseViewModel{
    
    private let reactionSelectSubject = BehaviorSubject(value: 0)
    
    struct Input{
        let reactions: [Int]
    }
    
    struct Output{
        
    }
    
    func transform(_ input: Input) -> Output {
        Output()
    }
}

extension FriendReactionSheetViewModel{
    func selectReaction(){
        
    }
}
