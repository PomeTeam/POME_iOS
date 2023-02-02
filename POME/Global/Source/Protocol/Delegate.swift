//
//  Delegate.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation

@objc protocol RecordCellWithEmojiDelegate{
    func requestGenerateFriendCardEmotion(reactionIndex: Int)
    func presentEmojiFloatingView(indexPath: IndexPath)
    @objc optional func presentReactionSheet(indexPath: IndexPath)
    @objc optional func presentEtcActionSheet(indexPath: IndexPath)
}
