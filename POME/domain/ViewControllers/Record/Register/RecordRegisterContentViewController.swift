//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class RecordRegisterContentViewController: BaseViewController {
    
    let mainView = RecordRegisterContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}
