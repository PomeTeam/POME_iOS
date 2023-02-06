//
//  DeleteUser.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import Foundation
import UIKit

class DeleteUserView: BaseView {
    // MARK: - Views
    let titleLabel = UILabel().then{
        $0.text = "계정을 삭제하려는 이유가 궁금해요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithSingleLine(typoStyle: .title1)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "불편하셨던 점을 알려주시면\n더 나은 서비스를 위해 노력하겠습니다."
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let completeButton = DefaultButton(titleStr: "확인").then{
        $0.inactivateButton()
    }
    var deleteUserTableView: UITableView!
    
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
        
        setTableView()
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        addSubview(deleteUserTableView)
        addSubview(completeButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        deleteUserTableView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(52)
        }
    }
    // MARK: - Methods
    func setTableView() {
        deleteUserTableView = UITableView().then{
            $0.register(DeleteUserTableViewCell.self, forCellReuseIdentifier: "DeleteUserTableViewCell")
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
