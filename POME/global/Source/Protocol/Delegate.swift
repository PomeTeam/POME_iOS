//
//  Delegate.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation

protocol CellDelegate{ //TableViewCell, CollectionViewCell 등에서 사용하는 delegate
    func sendCellIndex(row: Int)
}
