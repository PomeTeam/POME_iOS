//
//  FriendViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol FriendViewModelInterface{
    
}

class FriendViewModel: FriendViewModelInterface{
    
//    private let friendUseCase: GetFriendReviewUseCase
    
    struct Input{
        let viewWillAppear: Observable<Void>
        let friendId: Observable<Int>
        let leaveEmotionToFriend: ControlEvent<Void>
    }
    
    struct Output{
        let friends: Driver<[String]>
        let friendCards: Driver<[Reaction?]>
    }
    
//    func transform(input: Input) -> Output{
//        return Output(friends: <#Driver<[String]>#>,
//                      friendCards: <#Driver<[Reaction?]>#>)
//    }
    
    
}


 /* api
  1. 친구 리스트 조회
  2. 모든 친구 기록
  3. 특정 친구 기록
  4. 친구 기록에 리액션 남기기
  5. 친구 기록 숨기기
  */

