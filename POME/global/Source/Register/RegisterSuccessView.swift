//
//  GoalRegisterSuccessView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class RegisterSuccessView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "새로운 씀씀이 기록이\n추가되었어요!",
                                         subtitle: "잊지 않고 기록해주셨네요! 정말 대단해요")
    
    let iconImage = UIImageView().then{
        $0.image = Image.goalRegisterSuccess
    }
    
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
