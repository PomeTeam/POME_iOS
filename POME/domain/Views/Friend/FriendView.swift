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
    
    let titleLabel = UILabel().then{
        $0.text = "친구 응원하기"
//        $0.font = UIFont.autoPretendard(type: .b_18)
        $0.setTypoStyle(typoStyle: .header1)
        $0.textColor = Color.title
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumLineSpacing = 18
            $0.minimumInteritemSpacing = 18
            $0.itemSize = CGSize(width: 52, height: 96)
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.backgroundColor = Color.transparent
        
        $0.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.cellIdentifier)
        
    }
    
    let tableView = UITableView().then{
        
        $0.backgroundColor = Color.transparent
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
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
        self.addSubview(tableView)
    }
    
    override func constraint() {
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints{
            $0.height.equalTo(96)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom).offset(7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
