//
//  AppRegisterView.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import Foundation
import UIKit

class AppRegisterView: BaseView {
    let phoneLabel = UILabel().then{
        $0.text = "휴대전화 번호"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.body
    }
    let phoneTextField = DefaultTextField("- 없이 숫자만 입력해주세요", 16, 87).then{
        $0.keyboardType = .phonePad
    }
    var codeSendButton = DefaultButton(titleStr: "인증요청", typo: .title4, backgroundColor: Color.mint100, titleColor: .white, subTitleStr: "재요청")
    let codeLabel = UILabel().then{
        $0.text = "인증번호"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.body
    }
    let codeTextField = DefaultTextField(placeholderStr: "인증번호를 입력해주세요").then{
        $0.keyboardType = .numberPad
    }
    
    let notSendedButton = DefaultButton(titleStr: "인증번호가 오지 않나요?", typo: .subtitle2, backgroundColor: .white, titleColor: Color.grey5)
    let nextButton = DefaultButton(titleStr: "동의하고 시작하기").then{
        $0.isActivate(false)
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    override func style() {
        super.style()
        
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(phoneLabel)
        addSubview(phoneTextField)
        addSubview(codeSendButton)
        
        addSubview(codeLabel)
        addSubview(codeTextField)
        
        addSubview(notSendedButton)
        addSubview(nextButton)
    }
    
    override func layout() {
        super.layout()
        
        phoneLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
        }
        phoneTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(12)
            make.height.equalTo(46)
        }
        codeSendButton.snp.makeConstraints { make in
            make.width.equalTo(61)
            make.height.equalTo(28)
            make.trailing.equalTo(phoneTextField).offset(-16)
            make.centerY.equalTo(phoneTextField)
        }
        codeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(24)
        }
        codeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(codeLabel.snp.bottom).offset(12)
            make.height.equalTo(46)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-35)
        }
        notSendedButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-13)
            make.centerX.equalToSuperview()
        }
    }
}
