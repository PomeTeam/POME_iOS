//
//  GoalBannerTableViewCell.swift
//  POME
//
//  Created by 박소윤 on 2023/05/19.
//

import Foundation
import RxSwift

@frozen
enum GoalBanner{
    case registerInRecord
    case registerInReview
    case finish
}

class GoalBannerTableViewCell: BaseTableViewCell {
    
    var banner: GoalBanner!{
        didSet{
            setBannerStyle()
        }
    }
    
    private let backView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.setShadowStyle(type: .card)
    }
    private let bannerImage = UIImageView()
    private let titleLabel = UILabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .title3)
        $0.numberOfLines = 0
    }
    lazy var actionButton = UIButton().then{
        $0.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
    }

    override func hierarchy() {
        
        super.hierarchy()
        
        baseView.addSubview(backView)
        
        backView.addSubview(bannerImage)
        backView.addSubview(titleLabel)
        backView.addSubview(actionButton)
    }
    
    override func layout() {
        
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.equalTo(157)
        }
        bannerImage.snp.makeConstraints { make in
            make.width.height.equalTo(98)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bannerImage.snp.trailing).offset(30)
            make.top.equalToSuperview().offset(44)
        }
        actionButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
    }
    
    private func setBannerStyle(){
        let style = getStyle()
        bannerImage.image = style.bannerImage
        titleLabel.text = style.title
        actionButton.setTitle(style.btnTitle, for: .normal)
        actionButton.setTitleColor(style.btnColor, for: .normal)
    }
    
    private func getStyle() -> GoalBannerStyle{
        switch banner {
        case .registerInRecord:     return GoalRegisterInRecord()
        case .registerInReview:     return GoalRegisterInReview()
        case .finish:               return FinishGoal()
        default:                    fatalError()
        }
    }
}
