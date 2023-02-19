//
//  DeleteUserDetail.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import Foundation
import UIKit

class DeleteUserDetailView: BaseView {
    let contentArray = ["모든 목표 및 소비기록이 삭제돼요.", "친구정보, 획득한 마시멜로 등 모든 활동 정보가 삭제돼요.", "계정이 삭제된 후에는 계정을 다시 살릴 수 없어요.", "회원 탈퇴 후 7일간 재가입할 수 없어요."]
    // MARK: - Views
    let titleLabel = UILabel().then{
        let nickname = UserManager.nickName ?? ""
        $0.text = "\(nickname)님 잠깐만요!\n삭제하기 전에 읽어보세요."
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .title1)
        $0.textColor = Color.title
    }
    let contentLabel = UILabel().then{
        $0.numberOfLines = 0
    }
    let completeButton = DefaultButton(titleStr: "탈퇴하기").then{
        $0.activateButton()
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentLabel.setBulletPointList(strings: contentArray)
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
        addSubview(contentLabel)
        
        addSubview(completeButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(52)
        }
    }
}
