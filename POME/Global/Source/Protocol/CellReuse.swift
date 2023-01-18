//
//  CellReuse.swift
//  POME
//
//  Created by 박지윤 on 2023/01/18.
//

import Foundation

protocol CellReuse{
    static var cellIdentifier: String { get }
}

extension CellReuse{
    static var cellIdentifier: String {
        String(describing: self)
    }
}
