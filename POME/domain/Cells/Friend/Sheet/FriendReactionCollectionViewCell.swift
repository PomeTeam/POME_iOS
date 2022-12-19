//
//  FriendReactionCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionCollectionViewCell: BaseCollectionViewCell {
    
    static let cellIdenifier = "FriendReactionCollectionViewCell"
    
    /*
     left, right padding = 20
     spacing = 16
     */
    static let cellWidth: CGFloat = (Const.Device.WIDTH - (40 + 16 * 2)) / 3
    
    let reactionImage = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    let nicknameLabel = UILabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle3)
        $0.textColor = Color.body
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func hierarchy(){
        
        super.hierarchy()
        
        baseView.addSubview(reactionImage)
        baseView.addSubview(nicknameLabel)
    }
    
    override func layout(){
        
        baseView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        reactionImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(13.5)
            $0.height.equalTo(reactionImage.snp.width)
        }
        
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(reactionImage.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
