//
//  DeleteUserDetail.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import Foundation
import UIKit

class DeleteUserDetailView: BaseView {
    // MARK: - Views
    let titleLabel = UILabel().then{
        $0.text = "OO님 잠깐만요!\n삭제하기 전에 읽어보세요."
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .title1)
        $0.textColor = Color.title
    }
    let stack = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    let completeButton = DefaultButton(titleStr: "탈퇴하기").then{
        $0.activateButton()
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
        
        addSubview(titleLabel)
        addSubview(stack)
        
        setUpStack("모든 게시글 및 채팅방이 삭제돼요.")
        setUpStack("계정이 삭제 된 후에는 계정을 다시 살릴 수 없어요")
        setUpStack("회원 탈퇴 후 7일간 재가입할 수 없어요.")
        setUpStack("매너온도, 관심, 거래 후기 등 모든 활동 정보가 삭제되고 2줄 이상 시 이렇게 적혀요.")
        
        addSubview(completeButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        stack.snp.makeConstraints { make in
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
    func setUpStack(_ contentStr: String) {
        let contentLabel = UILabel().then{
            $0.text = "·  " + contentStr
            $0.numberOfLines = 0
            $0.setTypoStyleWithMultiLine(typoStyle: .body1)
            $0.textColor = Color.body
        }
        stack.addArrangedSubview(contentLabel)
    }
}
