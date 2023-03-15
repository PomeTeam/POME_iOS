//
//  GoalContentView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalContentView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "행복한 소비를 위한\n목표를 만들어보세요!",
                                            subtitle: "행복한 소비는 늘리고 후회되는 소비는 줄여봐요")
    
    let categoryField = RegisterCommonTextFieldView(title: "목표 카테고리",
                                                    placeholder: "택시/건강 (8자)").then{
        $0.infoTextField.countLimit = 8
    }
    let promiseField = RegisterCommonTextFieldView(title: "한 줄 다짐",
                                                   placeholder: "걸어다니기/건강 관리에는 넉넉히 쓰자 (18자)").then{
        $0.infoTextField.countLimit = 18
    }
    let priceField = RegisterCommonTextFieldView(title: "목표 금액",
                                                 placeholder: "50,000").then{
        $0.infoTextField.keyboardType = .numberPad
    }
    
    let goalMakePublicView = UIView().then{
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Color.pink10
    }
    
    let goalMakePublicTitle = UILabel().then{
        $0.text = "목표 공개 설정"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.title
    }
    
    let goalMakePublicSubTitle = UILabel().then{
        $0.text = "친구들에게 이 목표를 공개할까요?"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey6
    }
    
    let goalMakePublicSwitch = UISwitch().then{
        $0.onTintColor = Color.pink100
        $0.setOn(true, animated: false)
    }
    
    lazy var completeButton = DefaultButton(titleStr: "작성했어요").then{
        $0.isActivate(false)
    }
    
    func changeGoalMakePublicViewStatus(with: Bool){
        goalMakePublicView.backgroundColor =  with ? Color.pink10 : Color.grey1
    }
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(categoryField)
        self.addSubview(promiseField)
        self.addSubview(priceField)
        self.addSubview(goalMakePublicView)
        self.addSubview(completeButton)
        
        goalMakePublicView.addSubview(goalMakePublicTitle)
        goalMakePublicView.addSubview(goalMakePublicSubTitle)
        goalMakePublicView.addSubview(goalMakePublicSwitch)
    }
    
    override func layout() {
        titleView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        categoryField.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
        }
        
        promiseField.snp.makeConstraints{
            $0.top.equalTo(categoryField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        priceField.snp.makeConstraints{
            $0.top.equalTo(promiseField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(goalMakePublicView.snp.top).offset(10)
        }
        
        goalMakePublicView.snp.makeConstraints{
            $0.bottom.equalTo(completeButton.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        goalMakePublicTitle.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        goalMakePublicSubTitle.snp.makeConstraints{
            $0.top.equalTo(goalMakePublicTitle.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        goalMakePublicSwitch.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(35)
            $0.height.equalTo(52)
        }
    }
}
