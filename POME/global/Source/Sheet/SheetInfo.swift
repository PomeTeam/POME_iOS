//
//  SheetInfo.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import Foundation

enum SheetType: CGFloat{
    case friendReaction = 314
    case emotionFilter = 218
    case recordHome = 285
    case category = 378 //top offset이 378임..
    case calendar = 160 //cell 이외 offset 값 합 (24 + 24 + 16 + 20 + 52 + 4 * 6)
}
