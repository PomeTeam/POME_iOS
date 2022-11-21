//
//  TermsView.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import Foundation
import UIKit

class TermsView: BaseView {
    let titleLabel = UILabel().then{
        $0.text = "포미를 이용하려면\n아래 약관에 동의해주세요"
        $0.setTypoStyleWithMultiLine(typoStyle: .header1)
        $0.numberOfLines = 0
    }
    let allAgreeView = UIView().then{
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
    }
    let allAgreeLabel = UILabel().then{
        $0.text = "전체 동의"
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .body1)
    }
    var allAgreeCheck = TermCheckButton()
    
    let termStack = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 23     //
    }
    let useTermLabel = UILabel().then{
        $0.setUnderLine("이용 약관 동의 (필수)", UIFont.autoPretendard(type: .r_16), Color.title)
    }
    let privacyTermLabel = UILabel().then{
        $0.setUnderLine("개인정보 수집 및 이용 동의 (필수)", UIFont.autoPretendard(type: .r_16), Color.title)
    }
    let marketingTermLabel = UILabel().then{
        $0.setUnderLine("마케팅 정보 수집 동의 (선택)", UIFont.autoPretendard(type: .r_16), Color.title)
    }
    
    let checkStack = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 16
    }
    let useTermCheck = TermCheckButton()
    let privacyTermCheck = TermCheckButton()
    let marketingTermCheck = TermCheckButton()
    
    let agreeButton = DefaultButton(titleStr: "동의했어요")
    
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
        
        addSubview(titleLabel)
        
        addSubview(allAgreeView)
        allAgreeView.addSubview(allAgreeLabel)
        allAgreeView.addSubview(allAgreeCheck)
        
        addSubview(termStack)
        termStack.addArrangedSubview(useTermLabel)
        termStack.addArrangedSubview(privacyTermLabel)
        termStack.addArrangedSubview(marketingTermLabel)
        
        addSubview(checkStack)
        checkStack.addArrangedSubview(useTermCheck)
        checkStack.addArrangedSubview(privacyTermCheck)
        checkStack.addArrangedSubview(marketingTermCheck)
        
        addSubview(agreeButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.leading.equalToSuperview().offset(16)
        }
        allAgreeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(90)
            make.height.equalTo(50)
        }
        allAgreeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        allAgreeCheck.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        termStack.snp.makeConstraints { make in
            make.top.equalTo(allAgreeView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(38)
            make.width.equalTo(265)
        }
        checkStack.snp.makeConstraints { make in
            make.top.equalTo(termStack)
            make.trailing.equalToSuperview().offset(-38)
            make.leading.equalTo(termStack.snp.trailing).offset(10)
            make.width.equalTo(24)
        }
        useTermCheck.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        privacyTermCheck.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        marketingTermCheck.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        agreeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(52)
        }
    }
}
