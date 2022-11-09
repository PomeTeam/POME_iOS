//
//  EmojiFloatingView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

class EmojiFloatingView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: 38, height: 38)
            $0.minimumLineSpacing = 14
            $0.minimumInteritemSpacing = 14
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
//        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
//        $0.backgroundColor = Color.transparent
        
        $0.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.cellIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        self.setShadowStyle(type: .emojiFloating)
    }
    
    override func hierarchy() {
        self.addSubview(collectionView)
    }
    
    override func constraint() {
        collectionView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }

}
