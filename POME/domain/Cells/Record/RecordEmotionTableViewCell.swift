//
//  RecordEmotionTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class RecordEmotionTableViewCell: BaseTableViewCell {
    let illustrator = UIImageView().then{
        $0.image = Image.penMint
    }
    let titleLabel = UILabel().then{
        $0.text = "감정을 남겨주세요"
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    let messageLabel = UILabel().then{
        $0.text = "일주일이 지난 오늘, 그때의 씀씀이를 돌아보세요"
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey6
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let goalBannerView = UIView().then{
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
    }
    
    let goalTagStackView = UIStackView().then{
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    let goalIsPublicLabel = LockTagLabel.generateOpenTag()

    let goalRemainDateLabel = DayTagLabel.generateDateEndTag()
    
    let goalTitleLabel = UILabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
    }
    let recordCountLabel = UILabel().then{
        $0.text = "전체 0건"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
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
        
        self.contentView.addSubview(illustrator)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(goalBannerView)
        self.contentView.addSubview(recordCountLabel)
        
        goalBannerView.addSubview(goalTagStackView)
        goalBannerView.addSubview(goalTitleLabel)
        
        goalTagStackView.addArrangedSubview(goalIsPublicLabel)
        goalTagStackView.addArrangedSubview(goalRemainDateLabel)
    }
    override func layout() {
        super.layout()
        
        illustrator.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrator.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        goalBannerView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(83)
        }
        goalTagStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
        }
        goalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTagStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        recordCountLabel.snp.makeConstraints { make in
            make.top.equalTo(goalBannerView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
