//
//  ControlIndexPath.swift
//  POME
//
//  Created by 박소윤 on 2023/01/30.
//

import Foundation

protocol ControlIndexPath{
    var dataIndexBy: (IndexPath) -> Int { get }
}
