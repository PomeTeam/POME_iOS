//
//  FriendViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class FriendViewModel{
    
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
    
    /*
    init(friendUseCase: GetFriendReviewUseCase){

    }
     */
    
//    func transform(input: Input) -> Output{
//        return Output(friends: <#Driver<[String]>#>,
//                      friendCards: <#Driver<[Reaction?]>#>)
//    }
    
    
}

/*
 친구 리스트 get
 친구 카드 리스트 get
 
 */
