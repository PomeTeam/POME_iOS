//
//  TapGesture.swift
//  POME
//
//  Created by gomin on 2023/01/31.
//

import Foundation

class GoalTapGesture: UITapGestureRecognizer {
    var data: GoalResponseModel?
}

class FriendTapGesture: UITapGestureRecognizer {
    var data: FriendsResponseModel?
}

class RecordTapGesture: UITapGestureRecognizer {
    var data: RecordResponseModel?
}

class IndexPathTapGesture: UITapGestureRecognizer {
    var data: IndexPath!
}
