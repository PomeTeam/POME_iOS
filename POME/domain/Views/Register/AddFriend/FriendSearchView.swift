//
//  FriendSearchView.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class FriendSearchView: BaseView {
    // MARK: - Views
    let searchTextField = UITextField().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.placeholder = "친구의 닉네임을 검색해보세요"
        $0.font = UIFont.autoPretendard(type: .m_16)
        $0.textColor = Color.grey_9
        $0.backgroundColor = Color.grey_0
        $0.clearButtonMode = .never
        $0.addLeftPadding(16)
    }
    let searchButton = UIButton().then{
        $0.setImage(Image.search, for: .normal)
    }
    let completeButton = DefaultButton(titleStr: "완료했어요")
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    override func style() {
        searchTextField.inputAccessoryView = accessoryView // <-
    }
    override func hierarchy() {
        addSubview(searchTextField)
        addSubview(searchButton)
//        searchTextField.addSubview(searchButton)
        
        accessoryView.addSubview(completeButton)
    }
    override func constraint() {
        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.top.equalToSuperview().offset(12)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalTo(searchTextField.snp.trailing).offset(-17)
            make.centerY.equalTo(searchTextField)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}
