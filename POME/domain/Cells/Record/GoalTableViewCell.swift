//
//  GoalTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class GoalTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
    }
    let goalIsPublicLabel = LockTagLabel.generateUnopenTag()
    let goalRemainDateLabel = DayTagLabel.generateDateEndTag()
    let menuButton = UIButton().then{
        $0.setImage(Image.moreVertical, for: .normal)
    }
    let titleLabel = UILabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "사용 금액"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .title5)
    }
    let consumeLabel = UILabel().then{
        $0.text = "30,000원"
        $0.textColor = Color.body
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    let goalConsumeLabel = UILabel().then{
        $0.text = "· 100,000원"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    
    private let progressBarView = ProgressBarView()
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func setting() {
        super.setting()
        super.baseView.backgroundColor = Color.transparent
        
        // ProgressBar ratio
        self.progressBarView.ratio = 0.3
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        
        backView.addSubview(goalIsPublicLabel)
        backView.addSubview(goalRemainDateLabel)
        backView.addSubview(menuButton)
        
        backView.addSubview(titleLabel)
        backView.addSubview(subTitleLabel)
        
        backView.addSubview(consumeLabel)
        backView.addSubview(goalConsumeLabel)
        
        backView.addSubview(progressBarView)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.equalTo(157)
        }
        goalIsPublicLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
        }
        goalRemainDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(goalIsPublicLabel.snp.trailing).offset(4)
            make.top.equalTo(goalIsPublicLabel)
        }
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(14)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(goalIsPublicLabel.snp.bottom).offset(6)
            make.leading.equalTo(goalIsPublicLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        consumeLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(subTitleLabel)
        }
        goalConsumeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(consumeLabel)
            make.leading.equalTo(consumeLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        self.progressBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(goalConsumeLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(22)
        }
    }
}
