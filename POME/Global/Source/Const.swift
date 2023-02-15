//
//  Const.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import Foundation
import UIKit

struct Const{
    static let `default` = -1 //enum 형 등에서 default에 매핑되는 정수 값
    static let  requestPagingSize = 15
}

struct Device{
    static let WIDTH: CGFloat = UIScreen.main.bounds.size.width
    static let HEIGHT: CGFloat = UIScreen.main.bounds.size.height
    static let tabBarHeight: CGFloat = UITabBar().frame.height
}

struct Offset{
    static let VIEW_CONTROLLER_TOP: CGFloat = 92
}

struct ViewTag{
    static let select = 1
    static let deselect = 0
}
