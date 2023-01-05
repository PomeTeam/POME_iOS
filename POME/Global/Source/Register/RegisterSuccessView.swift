//
//  GoalRegisterSuccessView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit


class RegisterSuccessView: BaseView {
    
    let titleView = RegisterCommonTitleView()
    
    let iconImage = UIImageView()
    
    let completeButton = DefaultButton(titleStr: "확인했어요")

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(iconImage)
        self.addSubview(completeButton)
    }
    
    override func layout() {
        titleView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        iconImage.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(96)
            $0.leading.equalToSuperview().offset(53)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview()
            $0.top.greaterThanOrEqualTo(iconImage.snp.bottom)
        }
    }
    
}
