//
//  FriendDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

class FriendDetailViewController: BaseViewController {
    
    let mainView = FriendDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP + 24)
            $0.leading.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
    }

}
