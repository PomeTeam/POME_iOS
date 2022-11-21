//
//  GoEmotionBannerTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//

import UIKit

class GoEmotionBannerTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = Color.mint10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
    }
    let heartImage = UIImageView().then{
        $0.image = Image.heartMint
    }
    let titleLabel = BaseLabel().then{
        $0.text = "감정을 남겨주세요"
        $0.font = UIFont.autoPretendard(type: .sb_16)
        $0.numberOfLines = 0
    }
    let subTitleLabel = BaseLabel().then{
        $0.text = "다시 돌아볼 씀씀이가 0건 있어요"
        $0.font = UIFont.autoPretendard(type: .m_14)
        $0.numberOfLines = 0
        $0.textColor = Color.grey6
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
        super.baseView.backgroundColor = Color.transparent
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        backView.addSubview(heartImage)
        backView.addSubview(titleLabel)
        backView.addSubview(subTitleLabel)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(76)
        }
        heartImage.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(heartImage.snp.trailing).offset(10)
            make.top.equalTo(heartImage)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}
