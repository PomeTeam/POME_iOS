//
//  GoalTagsTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2023/01/18.
//

import Foundation

class GoalTagsTableViewCell: BaseTableViewCell{
    
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumInteritemSpacing = 8
            $0.minimumLineSpacing = 8
            $0.scrollDirection = .horizontal
        }
        
        $0.backgroundColor = Color.transparent
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.register(GoalTagCollectionViewCell.self, forCellWithReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier)
    }
    
    override func hierarchy() {
        super.hierarchy()
        baseView.addSubview(tagCollectionView)
    }
    
    override func layout() {
        super.layout()
        tagCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-6)
        }
    }
}
