//
//  ConsumeReviewTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ConsumeReviewTableViewCell: BaseTableViewCell {
    
    let shadowView = UIView().then{
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.grey2.cgColor
        $0.setShadowStyle(type: .card)
    }
    let mainView = ReviewDetailView().then{
        $0.memoLabel.numberOfLines = 2
    }
    
    override func setting(){
        super.setting()
        self.selectedBackgroundView = UIView()
    }
    
    override func hierarchy(){
        
        super.hierarchy()
        
        self.baseView.addSubview(shadowView)
        shadowView.addSubview(mainView)
    }
    
    override func layout(){
        
        super.layout()
        
        shadowView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(7)
            $0.bottom.equalToSuperview().offset(-7)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        mainView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
            $0.bottom.trailing.equalToSuperview().offset(-16)
        }
    }
}
