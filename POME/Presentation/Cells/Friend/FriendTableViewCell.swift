//
//  FriendTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class FriendTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    var delegate: RecordCellWithEmojiDelegate?
    
    private let mainView = FriendDetailView()
    private let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
    }
    
    //MARK: - LifeCycle
    
    override func prepareForReuse() {
        mainView.nameLabel.text = ""
        mainView.goalPromiseLabel.text = ""
        mainView.timeLabel.text = ""
        mainView.priceLabel.text = ""
        mainView.memoLabel.text = ""
        mainView.othersReactionCountLabel.text = ""
        
        mainView.firstEmotionTag.initialize()
        mainView.secondEmotionTag.initialize()
        
        mainView.myReactionBtn.setImage(Image.emojiAdd, for: .normal)
        mainView.othersReactionButton.setImage(.none, for: .normal)
    }
    
    //MARK: - Action
    
    @objc func myReactionBtnDidClicked(){
        if let index = getCellIndex(){
            delegate?.presentEmojiFloatingView!(indexPath: index)
        }
    }
    
    @objc func othersReactionBtnDidClicked(){
        if let index = getCellIndex(){
            delegate?.presentReactionSheet!(indexPath: index)
        }
    }
    
    @objc func moreButtonDidClicked(){
        if let index = getCellIndex(){
            delegate?.presentEtcActionSheet!(indexPath: index)
        }
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        baseView.addSubview(mainView)
        baseView.addSubview(separatorLine)
    }
    
    override func layout() {
        
        super.layout()
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-20)
        }
        separatorLine.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func initialize() {
        mainView.myReactionBtn.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
        mainView.othersReactionButton.addTarget(self, action: #selector(othersReactionBtnDidClicked), for: .touchUpInside)
        mainView.moreButton.addTarget(self, action: #selector(moreButtonDidClicked), for: .touchUpInside)
    }
    
    func bindingData(_ data: RecordResponseModel){
        mainView.dataBinding(with: data)
    }

}
