//
//  CommentView.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import Foundation
import UIKit

class CommentView: BaseView {
    let titleLabel = UILabel().then{
        $0.text = "한줄 코멘트"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let subtitleLabel = UILabel().then{
        $0.text = "목표를 달성하면서 어떤 변화를 느끼셨나요?"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let goalView = LittleGoalView()
    
    let textViewBackView = UIView().then{
        $0.backgroundColor = Color.grey0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
    }
    let commentTextView = UITextView().then{
        $0.text = "목표에 대한 한줄 코멘트를 남겨보세요"
        $0.font = UIFont.autoPretendard(type: .r_14)
        $0.textColor = Color.grey5
        $0.backgroundColor = Color.transparent
    }
    let countLabel = UILabel().then{
        $0.text = "00/150"
        $0.setTypoStyleWithSingleLine(typoStyle: .body2)
        $0.textColor = Color.grey2
    }
    
    let submitButton = DefaultButton(titleStr: "저장할게요")
    let notSubmitButton = DefaultButton(titleStr: "저장 안할래요", typo: .title3, backgroundColor: .white, titleColor: Color.grey4)
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
        addSubview(subtitleLabel)
        addSubview(goalView)
        
        addSubview(textViewBackView)
        textViewBackView.addSubview(commentTextView)
        textViewBackView.addSubview(countLabel)
        
        addSubview(submitButton)
        addSubview(notSubmitButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
        }
        goalView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(83)
        }
        textViewBackView.snp.makeConstraints { make in
            make.top.equalTo(goalView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(188)
        }
        commentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(132)
        }
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-34)
        }
        notSubmitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
        }
    }
}
