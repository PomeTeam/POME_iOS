//
//  TabBarController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var recordViewController = RecordViewController(btnImage: UIImage())
    
    override func viewDidLoad() {

        generateAccessToken()
        
        super.viewDidLoad()

        setupShadow()
        setTabBarAppearance()
        setTabBarItems()
    }
    
    private func generateAccessToken(){
        
        UserService.shared.signIn(model: SignInRequestModel(phoneNum: UserManager.phoneNum ?? "" )){ result in
            switch result{
            case .success(let data):
                print("LOG: SUCCESS GENERATE TOKEN")
                UserManager.token = data.accessToken
                self.recordViewController.requestGetGoals()
                break
            default:
                print("LOG: FAIL GENERATE TOKEN")
                UserManager.token = ""
            }
        }
    }

    func setupShadow() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: Color.tabBarShadow, alpha: 1, x: 0, y: -10, blur: 14)
    }
    
    private func setTabBarAppearance() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = Color.mint100
        UITabBar.appearance().unselectedItemTintColor = Color.grey4
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.autoPretendard(type: .sb_10)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    
    func setTabBarItems(){
        
        let tabs = [UINavigationController(rootViewController: recordViewController),
                    UINavigationController(rootViewController: ReviewTestViewController(btnImage: UIImage())),
                    UINavigationController(rootViewController: FriendViewController(btnImage: Image.addPeople)),
                    UINavigationController(rootViewController: MyPageViewController(btnImage: Image.setting))]
        
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
//            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabs, animated: true)
    }

}
