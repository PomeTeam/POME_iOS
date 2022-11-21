//
//  GoEmotionBannerTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//

import UIKit

class GoEmotionBannerTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = Color.mint20
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
    }
    let titleLabel = UILabel().then{
        $0.text = "일주일 씀씀이"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let heartImage = UIImageView().then{
        $0.image = Image.heartMint
    }
    let bannerTitleLabel = UILabel().then{
        $0.text = "감정을 남겨주세요"
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.numberOfLines = 0
    }
    let subTitleLabel = UILabel().then{
        $0.text = "다시 돌아볼 씀씀이가 0건 있어요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
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
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(backView)
        backView.addSubview(heartImage)
        backView.addSubview(bannerTitleLabel)
        backView.addSubview(subTitleLabel)
    }
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(74)
        }
        heartImage.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        bannerTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(heartImage.snp.trailing).offset(10)
            make.top.equalTo(heartImage)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bannerTitleLabel)
            make.top.equalTo(bannerTitleLabel.snp.bottom).offset(4)
        }
    }
}
