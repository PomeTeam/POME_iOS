//
//  RecordRegisterView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class RecordRegisterContentView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "어떤 소비를 하셨나요?",
                                         subtitle: "소비에 대한 간단한 기록을 남겨보세요")
    
    let goalField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.arrowDown, title: "목표", placeholder: "목표를 선택해주세요")
    
    let dateField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.calendar, title: "소비날짜", placeholder: "")
    
    let amountField = RegisterCommonTextFieldView(title: "소비 금액",
                                                  placeholder: "10,000")
    
    let contentView = UIView()
    
    let contentTitle = UILabel().then{
        $0.text = "소비 기록"
        $0.font = UIFont.autoPretendard(type: .sb_14)
        $0.textColor = Color.body
    }
    
    let contentTextView = UITextView()
    
    let contentNumberOfCharactersLabel = UILabel().then{
        $0.text = "00/150"
        $0.textColor = Color.grey2
        $0.setTypoStyleWithSingleLine(typoStyle: .body2)
    }
    
    lazy var completeButton = DefaultButton(titleStr: "작성했어요")
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {}
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(goalField)
        self.addSubview(dateField)
        self.addSubview(amountField)
        self.addSubview(contentView)
        self.addSubview(completeButton)
        
        contentView.addSubview(contentTitle)
        contentView.addSubview(contentTextView)
        contentTextView.addSubview(contentNumberOfCharactersLabel)
    }
    
    override func layout() {
        
        titleView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        goalField.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        dateField.snp.makeConstraints{
            $0.top.equalTo(goalField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        amountField.snp.makeConstraints{
            $0.top.equalTo(dateField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.top.equalTo(amountField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentTitle.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentTextView.snp.makeConstraints{
            $0.top.equalTo(contentTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(completeButton.snp.top).offset(-21)
        }
        
        contentNumberOfCharactersLabel.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        completeButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}
