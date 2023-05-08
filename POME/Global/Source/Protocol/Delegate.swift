//
//  Delegate.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation

protocol RecordCellDelegate{
    func presentReactionSheet(indexPath: IndexPath)
    func presentEtcActionSheet(indexPath: IndexPath)
}

protocol FriendRecordCellDelegate: RecordCellDelegate{
    func willShowReactionFloatingView(indexPath: IndexPath)
}

