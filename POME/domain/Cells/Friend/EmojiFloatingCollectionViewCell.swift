//
//  EmojiFloatingCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

class EmojiFloatingCollectionViewCell: BaseCollectionViewCell {
    
    static let cellIdentifier = "EmojiFloatingCollectionViewCell"
    
    let emojiImage = UIImageView()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func hierarchy(){
        super.hierarchy()
        
        self.baseView.addSubview(emojiImage)
    }
    
    override func layout(){
        super.layout()
        
        emojiImage.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(38)
        }
    }
    
}
