//
//  GoalDateView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalDateView: BaseView {
    
    let titleView = GoalCommomnTitleView(title: "시작이 반이에요!\n오늘부터 언제까지 해볼까요?",
                                         subtitle: "최대 한달까지 목표를 세울 수 있어요")
    let startDateField = GoalDateTextFieldView(title: "목표 시작 날짜",
                                               placeholder: "목표 시작 날짜를 선택해주세요")
    
    let endDateField = GoalDateTextFieldView(title: "목표 종료 날짜",
                                            placeholder: "목표 종료 날짜를 선택해주세요")
    
    lazy var completButton = DefaultButton(titleStr: "선택했어요").then{
        $0.isActivate(true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(startDateField)
        self.addSubview(endDateField)
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
        
        completButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    
}

extension GoalDateView{
    
    class GoalDateTextFieldView: GoalCommonTextFieldView{
        
        lazy var calendarButton = UIButton().then{
            $0.setImage(Image.calendar, for: .normal)
        }
        
        override init(title: String, placeholder: String){
            super.init(title: title, placeholder: placeholder)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func style() {
            self.infoTextField.addRightPadding(50)
        }
        
        override func hierarchy() {
            
            super.hierarchy()

            infoTextField.addSubview(calendarButton)
        }
        
        override func layout() {

            super.layout()
            
            calendarButton.snp.makeConstraints{
                $0.top.equalToSuperview().offset(11)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(calendarButton.snp.height)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
        
    }
}
