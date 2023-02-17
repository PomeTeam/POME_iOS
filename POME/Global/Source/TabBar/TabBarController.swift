//
//  TabBarController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class TabBarController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()
        setTabBarItems()
    }
    
    private func setTabBarAppearance() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = Color.mint100
        UITabBar.appearance().unselectedItemTintColor = Color.grey4
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.autoPretendard(type: .sb_10)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    
    func setTabBarItems(){
        
        let tabs = [UINavigationController(rootViewController: RecordViewController(btnImage: UIImage())),
                    UINavigationController(rootViewController: ReviewViewController(btnImage: UIImage())),
                    UINavigationController(rootViewController: FriendViewController(btnImage: Image.addPeople)),
                    UINavigationController(rootViewController: MyPageViewController(btnImage: Image.setting))]
        
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
//            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabs, animated: true)
    }

}
