//
//  EmojiFloatingView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

class EmojiFloatingView: BaseView {
    
    let shadowView = UIView().then{
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .emojiFloating)
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: 38, height: 38)
            $0.minimumLineSpacing = 14
            $0.minimumInteritemSpacing = 14
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.backgroundColor = Color.transparent
        
        $0.register(EmojiFloatingCollectionViewCell.self, forCellWithReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        
        self.addGestureRecognizer(dismissGesture)
    }
    
    @objc func dismiss(){
        self.removeFromSuperview()
    }
    
    override func hierarchy() {
        self.addSubview(shadowView)
        
        shadowView.addSubview(collectionView)
    }
    
    override func constraint() {

        shadowView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(29)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }

}
