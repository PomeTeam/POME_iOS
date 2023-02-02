//
//  Delegate.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation

protocol EmojiCellDelegate{
    func requestGenerateFriendCardEmotion(reactionIndex: Int)
}

protocol FriendCellDelegate{
    func presentEmojiFloatingView(indexPath: IndexPath)
    func presentReactionSheet(indexPath: IndexPath)
    func presentEtcActionSheet(indexPath: IndexPath)
}
