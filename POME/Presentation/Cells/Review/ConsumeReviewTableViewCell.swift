//
//  ConsumeReviewTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ConsumeReviewTableViewCell: BaseTableViewCell {
    
    var delegate: RecordCellDelegate?
    
    private let shadowView = UIView().then{
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.grey2.cgColor
        $0.setShadowStyle(type: .card)
    }
    private let mainView = ReviewDetailView()
    
    override func prepareForReuse() {
        mainView.tagLabel.text = ""
        mainView.timeLabel.text = ""
        mainView.priceLabel.text = ""
        mainView.memoLabel.text = ""
        mainView.rightReactionCountLabel.text = ""
        
        mainView.firstEmotionTag.initialize()
        mainView.secondEmotionTag.initialize()
        
        mainView.leftReactionButton.setImage(.none, for: .normal)
        mainView.rightReactionButton.setImage(.none, for: .normal)
        
        mainView.rightReactionCountLabel.isHidden = true
    }
    
    override func hierarchy(){
        
        super.hierarchy()
        
        baseView.addSubview(shadowView)
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
    
    override func initialize() {
        mainView.rightReactionButton.addTarget(self, action: #selector(othersFriendReactionButtonDidTapped), for: .touchUpInside)
        mainView.moreButton.addTarget(self, action: #selector(moreButtonDidClicked), for: .touchUpInside)
    }
    
    //MARK: - Action
    
    @objc private func othersFriendReactionButtonDidTapped(){
        if let index = getCellIndex(){
            delegate?.presentReactionSheet(indexPath: index)
        }
    }
    
    @objc private func moreButtonDidClicked(){
        if let index = getCellIndex(){
            delegate?.presentEtcActionSheet(indexPath: index)
        }
    }
    
    func bindingData(with: RecordResponseModel){
        mainView.dataBinding(with: with)
    }
}
