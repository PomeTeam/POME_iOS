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
    
    init(type: RegisterSuccessType){
        super.init(nibName: nil, bundle: nil)
        mainView.titleView.titleLabel.text = type.title
        mainView.titleView.subtitleLabel.text = type.subtitle
        mainView.iconImage.image = type.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func completeButtonDidClickec(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
