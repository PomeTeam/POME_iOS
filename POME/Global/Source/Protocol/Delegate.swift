//
//  Delegate.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation

protocol CellDelegate{ //TableViewCell, CollectionViewCell 등에서 사용하는 delegate
    func sendCellIndex(indexPath: IndexPath)
}

protocol FriendCellDelegate{
    func presentEmojiFloatingView(indexPath: IndexPath)
    func presentReactionSheet(indexPath: IndexPath)
    func presentEtcActionSheet(indexPath: IndexPath)
}
