//
//  RegisterView.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class RegisterView: BaseView {
    // MARK: - Views
    let registerTitleLabel = UILabel().then{
        $0.text = "나만의 프로필을\n만들어볼까요?"
        $0.textColor = Color.title
        $0.setTypoStyleWithMultiLine(typoStyle: .header1)
        $0.numberOfLines = 0
    }
    let profileImage = UIImageView().then{
        $0.image = Image.photoDefault
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 75
    }
    let profileButton = UIButton().then{
        $0.setImage(Image.plus, for: .normal)
    }
    let nameTextField = DefaultTextField("영문/한글 최대 10자 이내", 16, 13).then{
        $0.backgroundColor = Color.grey0
        $0.font = UIFont.autoPretendard(type: .r_14)
        $0.textColor = Color.title
        $0.setClearButton(mode: .whileEditing)
    }
    let messageLabel = UILabel().then{
        $0.text = "멋진 닉네임이네요!"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.mint100
    }
    let guideLabel = UILabel().then{
        $0.text = "입력한 정보는 회원을 식별하고 친구간 커뮤니케이션을 위한\n동의 목적으로만 사용되며 포미 이용기간 동안 보관돼요"
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle3)
        $0.textAlignment = .center
        $0.textColor = Color.grey5
        $0.numberOfLines = 0
    }
    var completeButton = DefaultButton(titleStr: "입력했어요").then{
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
        messageLabel.isHidden = true
    }
    override func hierarchy() {
        addSubview(registerTitleLabel)
        addSubview(profileImage)
        addSubview(profileButton)
        
        addSubview(nameTextField)
        addSubview(messageLabel)
        
        addSubview(completeButton)
        addSubview(guideLabel)
    }
    
    override func layout() {
        registerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(super.safeAreaLayoutGuide).offset(56)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(registerTitleLabel.snp.bottom).offset(44)
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
        profileButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(profileImage).offset(-8)
            make.bottom.equalTo(profileImage).offset(-9)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(profileImage.snp.bottom).offset(40)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.equalTo(nameTextField)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(super.safeAreaLayoutGuide).offset(-14)
        }
        guideLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(42)
            make.bottom.equalTo(completeButton.snp.top).offset(-20)
        }
    }
}
