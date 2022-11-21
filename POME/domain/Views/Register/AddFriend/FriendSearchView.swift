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
        $0.textColor = Color.title
        $0.backgroundColor = Color.grey0
        $0.clearButtonMode = .never
        $0.addLeftPadding(16)
    }
    let searchButton = UIButton().then{
        $0.setImage(Image.search, for: .normal)
    }
    let completeButton = DefaultButton(titleStr: "완료했어요")
    let completeButtonBottom = DefaultButton(titleStr: "완료했어요")
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    
    // MARK: - Life Cycle
    var searchTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    override func style() {
        searchTextField.inputAccessoryView = accessoryView // <-
        searchTableView = UITableView()
        
        hideEmptyView()
    }
    override func hierarchy() {
        addSubview(searchTextField)
        addSubview(searchButton)
        addSubview(completeButtonBottom)
        addSubview(searchTableView)
        
        accessoryView.addSubview(completeButton)
    }
    override func layout() {
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
        completeButtonBottom.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        searchTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.bottom.equalTo(completeButtonBottom.snp.top)
        }
    }
    func setTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        searchTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(FriendSearchTableViewCell.self, forCellReuseIdentifier: "FriendSearchTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
// MARK: Empty View
extension FriendSearchView {
    func showEmptyView() {
        let stack = UIView().then{
            $0.backgroundColor = .clear
        }
        let warningImage = UIImageView().then{
            $0.image = Image.warning
        }
        let messageLabel = UILabel().then{
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.textColor = Color.grey5
            $0.textAlignment = .center
            $0.text = "검색 결과가 없어요\n다른 닉네임으로 검색해볼까요?"
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: searchTableView.bounds.width, height: searchTableView.bounds.height))
        
        stack.addSubview(warningImage)
        stack.addSubview(messageLabel)
        backgroudView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.centerX.centerY.equalToSuperview()
        }
        warningImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(warningImage.snp.bottom).offset(12)
        }
        
        searchTableView.backgroundView = backgroudView
    }
    func hideEmptyView() {
        searchTableView.backgroundView?.isHidden = true
    }
}
