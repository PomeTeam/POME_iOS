//
//  BaseTabViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit
import SnapKit
import Then

class BaseTabViewController: UIViewController {
    
    lazy var navigationView = UIView()
    
    lazy var topBtn = UIButton().then{
        $0.addTarget(self, action: #selector(topBtnDidClicked), for: .touchUpInside)
    }
    
    init(btnImage: UIImage){
        super.init(nibName: nil, bundle: nil)
        self.topBtn.setImage(btnImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    func style() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func layout() {
        
        self.view.addSubview(navigationView)
        self.navigationView.addSubview(topBtn)
        
        navigationView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        topBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(topBtn.snp.height)
        }
    }
    
    func initialize() {}
    
    @objc func topBtnDidClicked() {} //각 TabVC에서 topBtnDidClicked를 override해서 event 기능 구현하면 됩니다.

}

extension BaseTabViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
