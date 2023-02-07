//
//  Pageable.swift
//  POME
//
//  Created by 박소윤 on 2023/02/07.
//

import Foundation

protocol Pageable{
    var page: Int { get set }
    var isPaging: Bool { get set }
    var hasNextPage: Bool { get set }
    func beginPaging()
    func recordRequestIsEmpty()
}
