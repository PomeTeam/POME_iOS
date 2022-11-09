//
//  RegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit

class RegisterViewController: UIViewController {
    let registerTitleLabel = UILabel().then{
        $0.text = "나만의 프로필을\n만들어볼까요?"
        $0.textColor = Color.grey_9
        $0.font = UIFont.autoPretendard(type: .b_24)
        $0.numberOfLines = 0
    }
    let profileImage = UIImageView().then{
        $0.image = Image.photoDefault
    }
    let profileButton = UIButton().then{
        $0.setImage(Image.plus, for: .normal)
    }
    let nameTextField = UITextField().then{
        $0.backgroundColor = Color.grey_0
        $0.placeholder = "영어, 한국어 최대 10자 이내 입력"
        $0.clearButtonMode = .always
        $0.font = UIFont.autoPretendard(type: .m_16)
        $0.textColor = Color.grey_9
        $0.layer.cornerRadius = 6
        $0.addLeftPadding(16)
    }
    let messageLabel = UILabel().then{
        $0.text = "멋진 닉네임이네요!"
        $0.font = UIFont.autoPretendard(type: .m_14)
        $0.textColor = Color.main
    }
    let guideLabel = UILabel().then{
        $0.text = "입력한 정보는 회원을 식별하고 친구간 커뮤니케이션을 위한\n동의 목적으로만 사용되며 포미 이용기간 동안 보관돼요"
        $0.font = UIFont.autoPretendard(type: .m_12)
        $0.textColor = Color.grey_5
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    var completeButton = DefaultButton(titleStr: "입력했어요").then{
        $0.isActivate(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        initialize()
    }
    
    func layout() {
        self.view.addSubview(registerTitleLabel)
        self.view.addSubview(profileImage)
        profileImage.addSubview(profileButton)
        
        self.view.addSubview(nameTextField)
        self.view.addSubview(messageLabel)
        
        self.view.addSubview(completeButton)
        self.view.addSubview(guideLabel)
        
        registerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(registerTitleLabel.snp.bottom).offset(44)
            make.width.height.equalTo(160)
            make.centerX.equalToSuperview()
        }
        profileButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-14)
        }
        guideLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(42)
            make.bottom.equalTo(completeButton.snp.top).offset(-20)
        }
    }
    func initialize() {
        completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }

    @objc func completeButtonDidTap() {
        print("click!")
    }
}
