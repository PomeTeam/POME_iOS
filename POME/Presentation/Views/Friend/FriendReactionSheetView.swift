//
//  FriendReactionSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetView: BaseView {
    
    //MARK: - Properties
    
    let reactionTypeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: ReactionTypeCollectionViewCell.cellWidth, height: ReactionTypeCollectionViewCell.cellWidth)
            $0.minimumLineSpacing = 14
        }
        
        $0.collectionViewLayout = flowLayout
        $0.contentInset = UIEdgeInsets(top: 0, left: 16.5, bottom: 0, right: 16.5)
        
        $0.register(cellType: ReactionTypeCollectionViewCell.self)
    }
    
    private let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
    }
    private let countView = UIView()
    
    let countLabel = UILabel().then{
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
    
    //MARK: - Override
    
    override func hierarchy() {
        addSubview(reactionTypeCollectionView)
        addSubview(separatorLine)
        addSubview(countView)
        addSubview(friendReactionCollectionView)
        countView.addSubview(countLabel)
    }
    
    override func layout() {
        
        reactionTypeCollectionView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(ReactionTypeCollectionViewCell.cellWidth)
        }
        
        separatorLine.snp.makeConstraints{
            $0.bottom.equalTo(reactionTypeCollectionView).offset(10)
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
        }
    }
    
}
