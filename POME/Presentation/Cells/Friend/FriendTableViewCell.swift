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
    
    let mainView = FriendDetailView().then{
        $0.myReactionBtn.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
        $0.othersReactionButton.addTarget(self, action: #selector(othersReactionBtnDidClicked), for: .touchUpInside)
        $0.moreButton.addTarget(self, action: #selector(moreButtonDidClicked), for: .touchUpInside)
        
        $0.memoLabel.numberOfLines = 2
    }
    
    //
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
        
    }
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        mainView.nameLabel.text = ""
        mainView.goalPromiseLabel.text = ""
        mainView.timeLabel.text = ""
        mainView.priceLabel.text = ""
        mainView.memoLabel.text = ""
        mainView.othersReactionCountLabel.text = ""
        
        mainView.myReactionBtn.setImage(Image.emojiAdd, for: .normal)
    }
    
    //MARK: - Action
    
    @objc func myReactionBtnDidClicked(){
        
        guard let index = getCellIndex() else { return }

        delegate?.presentEmojiFloatingView(indexPath: index)
    }
    
    @objc func othersReactionBtnDidClicked(){
        
        guard let index = getCellIndex() else { return }

        delegate?.presentReactionSheet!(indexPath: index)
    }
    
    @objc func moreButtonDidClicked(){
        
        guard let index = getCellIndex() else { return }
        
        delegate?.presentEtcActionSheet!(indexPath: index)
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.baseView.addSubview(mainView)
        self.baseView.addSubview(separatorLine)
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

}
