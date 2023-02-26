//
//  GoalDateView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalDateView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "시작이 반이에요!\n오늘부터 언제까지 해볼까요?",
                                         subtitle: "최대 한달까지 목표를 세울 수 있어요")
    let startDateField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.calendar, title: "목표 시작 날짜", placeholder: "목표 시작 날짜를 선택해주세요")
    
    let endDateField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.calendar, title: "목표 종료 날짜", placeholder: "목표 종료 날짜를 선택해주세요").then{
        $0.isUserInteractionEnabled = false
    }
    
    let invalidationDateRangeLabel = UILabel().then{
        $0.isHidden = true
        $0.text = "목표 기간은 한 달 이내로 설정할 수 있어요!"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.red
    }
    
    lazy var completButton = DefaultButton(titleStr: "선택했어요").then{
        $0.isActivate(false)
    }
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(startDateField)
        self.addSubview(endDateField)
        self.addSubview(invalidationDateRangeLabel)
        self.addSubview(completButton)
    }
    
    override func layout() {
        
        titleView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        startDateField.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
        }
        
        endDateField.snp.makeConstraints{
            $0.top.equalTo(startDateField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        invalidationDateRangeLabel.snp.makeConstraints{
            $0.top.equalTo(endDateField.infoTextField.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        completButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    
}
