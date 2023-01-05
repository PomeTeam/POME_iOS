//
//  NotiTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class NotiTableViewCell: BaseTableViewCell {
    let iconImg = UIButton().then{
        $0.setImage(Image.heartPink, for: .normal)
        $0.setImage(Image.completeCircle, for: .selected)
        $0.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
    }
    let titleLabel = UILabel().then{
        $0.text = "돌아보기"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
        $0.textColor = Color.body
    }
    let timeLabel = UILabel().then{
        $0.text = "· 1시간 전"
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
        $0.textColor = Color.grey6
    }
    let messageLabel = UILabel().then{
        $0.text = "기록을 남긴지 일주일이 되었어요!\n일주일이 지난 오늘의 감정을 남겨주세요"
        $0.textColor = Color.body
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
        $0.numberOfLines = 0
    }

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
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(iconImg)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(messageLabel)
    }
    override func layout() {
        super.layout()
        
        iconImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(14)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.centerY.equalTo(iconImg)
            make.leading.equalTo(iconImg.snp.trailing).offset(8)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.top.bottom.centerY.equalTo(titleLabel)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImg.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    func setComplete() {
        self.iconImg.isSelected = true
        self.titleLabel.text = "목표종료"
        self.messageLabel.text = "목표 기간이 종료되었어요!\n기록을 돌아보고 새로운 목표를 시작해봐요"
    }
}
