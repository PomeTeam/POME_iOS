//
//  GoalRegisterSuccessViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class RegisterSuccessViewController: UIViewController {
    
    let mainView = RegisterSuccessView().then{
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClickec), for: .touchUpInside)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        layout()
    }
    
    func layout(){
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func completeButtonDidClickec(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
