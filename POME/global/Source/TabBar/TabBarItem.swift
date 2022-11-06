//
//  TabBarItem.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case record
    case review
    case friend
    case mypage
}

extension TabBarItem {
    var title: String {
        switch self {
        case .record:     return "기록"
        case .review:     return "회고"
        case .friend:     return "친구"
        case .mypage:     return "마이"
        }
    }
}

extension TabBarItem {
    var inactiveIcon: UIImage? {
        switch self {
        case .record:     return Image.recordInactivate
        case .review:     return Image.reviewInactivate
        case .friend:     return Image.friendInactivate
        case .mypage:     return Image.mypageInactivate
        }
    }
    
    var activeIcon: UIImage? {
        switch self {
        case .record:     return Image.recordActivate
        case .review:     return Image.reviewActivate
        case .friend:     return Image.friendActivate
        case .mypage:     return Image.mypageActivate
        }
    }
}

extension TabBarItem {
    public func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: title,
            image: inactiveIcon,
            selectedImage: activeIcon
        )
    }
}


