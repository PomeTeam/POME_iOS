//
//  FriendReactionSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetView: BaseView {
    
    //MARK: - Properties
    
    let emotionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: ReactionTypeCollectionViewCell.cellWidth, height: ReactionTypeCollectionViewCell.cellWidth)
            $0.minimumLineSpacing = 14
        }
        
        $0.collectionViewLayout = flowLayout
        $0.contentInset = UIEdgeInsets(top: 0, left: 16.5, bottom: 0, right: 16.5)
        
        $0.register(ReactionTypeCollectionViewCell.self, forCellWithReuseIdentifier: ReactionTypeCollectionViewCell.cellIdenifier)
    }
    
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
    }
    
    let countView = UIView()
    
    let countLabel = UILabel().then{
        $0.text = "전체 6개"
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle3)
        $0.textColor = Color.body
    }
    
    let friendReactionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: FriendReactionCollectionViewCell.cellWidth, height: FriendReactionCollectionViewCell.cellWidth)
            $0.minimumLineSpacing = 20
            $0.minimumInteritemSpacing = 16
        }
        
        $0.collectionViewLayout = flowLayout
        
        $0.register(FriendReactionCollectionViewCell.self, forCellWithReuseIdentifier: FriendReactionCollectionViewCell.cellIdenifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        self.addSubview(emotionCollectionView)
        self.addSubview(separatorLine)
        self.addSubview(countView)
        self.addSubview(friendReactionCollectionView)
        
        countView.addSubview(countLabel)
    }
    
    override func layout() {
        
        emotionCollectionView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(ReactionTypeCollectionViewCell.cellWidth)
        }
        
        separatorLine.snp.makeConstraints{
            $0.bottom.equalTo(emotionCollectionView).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        countView.snp.makeConstraints{
            $0.height.equalTo(34)
            $0.top.equalTo(separatorLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        friendReactionCollectionView.snp.makeConstraints{
            $0.top.equalTo(countView.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
//                .offset(-10)
        }
    }
    
}
