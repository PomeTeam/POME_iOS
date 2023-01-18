//
//  GoalDetailTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2023/01/18.
//

import Foundation

class GoalDetailTableViewCell: BaseTableViewCell{
    
    static let cellIdentifier = "GoalDetailTableViewCell"
    
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
    
    override func hierarchy() {
        
        super.hierarchy()
        
        baseView.addSubview(goalBannerView)
        
        goalBannerView.addSubview(goalTagStackView)
        goalBannerView.addSubview(goalTitleLabel)
        
        goalTagStackView.addArrangedSubview(goalIsPublicLabel)
        goalTagStackView.addArrangedSubview(goalRemainDateLabel)
    }
    
    override func layout() {
        
        super.layout()
        
        goalBannerView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.height.equalTo(83)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        goalTagStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalTitleLabel.snp.makeConstraints{
            $0.top.equalTo(goalTagStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-14)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
