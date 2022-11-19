//
//  FriendView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import Foundation
import UIKit

class FriendView: BaseView{
    
    //MARK: - UI
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumLineSpacing = 16
            $0.minimumInteritemSpacing = 16
            $0.itemSize = FriendCollectionViewCell.cellSize
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 16)

        $0.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.cellIdentifier)
        
    }
    
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
    }
    
    let tableView = UITableView().then{
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)
        
        $0.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.cellIdentifier)
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    override func hierarchy() {
        self.addSubview(collectionView)
        self.addSubview(separatorLine)
        self.addSubview(tableView)
    }
    
    override func layout() {
        
        collectionView.snp.makeConstraints{
            $0.height.equalTo(86)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(collectionView)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
