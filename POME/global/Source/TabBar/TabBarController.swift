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
        UITabBar.appearance().tintColor = UIColor.main
        UITabBar.appearance().unselectedItemTintColor = UIColor.grey_4
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.autoPretendard(type: .sb_10)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    
    func setDelegate(){
        self.delegate = self
    }
    
    func setTabBarItems(){
        
        let tabs = [UINavigationController(rootViewController: RecordViewController(btnImage: UIImage.alarm_activate)),
                    UINavigationController(rootViewController: ReviewViewController(btnImage: UIImage.alarm_activate)),
                    UINavigationController(rootViewController: FriendViewController(btnImage: UIImage.add_people)),
                    UINavigationController(rootViewController: MyPageViewController(btnImage: UIImage.setting))
                    ]
        
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabs, animated: true)
    }

}

extension TabBarController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabBarItemIndex = viewController.tabBarItem.tag
        return true
    }
}
