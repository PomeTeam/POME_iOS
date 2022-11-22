//
//  AlarmSettingViewController.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class AlarmSettingViewController: BaseViewController {
    var alartSettingView: AlarmSettingView!
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "알림 설정")
        
    }
    override func layout() {
        super.layout()
        
        alartSettingView = AlarmSettingView()
        self.view.addSubview(alartSettingView)
        alartSettingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }

}
