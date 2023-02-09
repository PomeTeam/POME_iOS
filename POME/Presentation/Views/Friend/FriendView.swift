//
//  FriendView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import Foundation
import UIKit

class FriendView: BaseView{
    
    let emptyView = FriendTableEmptyView()
    
    let tableView = UITableView().then{
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 74, right: 0)
        
        $0.backgroundView = FriendTableEmptyView()
        
        $0.register(cellType: LoadingTableViewCell.self)
        $0.register(FriendListTableViewCell.self, forCellReuseIdentifier: FriendListTableViewCell.cellIdentifier)
        $0.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.cellIdentifier)
    }
    
    override func hierarchy() {
        self.addSubview(tableView)
        tableView.backgroundView = emptyView
    }
    
    override func layout() {
        
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.backgroundView?.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    func emptyViewWillShow(case type: FriendTableEmptyView.EmptyViewInfo){
        (tableView.backgroundView as? FriendTableEmptyView)?.emptyLabel.text = type.rawValue
        tableView.backgroundView?.isHidden = false
    }
    
    func emptyViewWillHide(){
        tableView.backgroundView?.isHidden = true
    }
}

extension FriendView{
    
    class FriendListTableViewCell: BaseTableViewCell{
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            
            let flowLayout = UICollectionViewFlowLayout().then{
                $0.minimumLineSpacing = 16
                $0.minimumInteritemSpacing = 16
                $0.itemSize = FriendCollectionViewCell.cellSize
                $0.scrollDirection = .horizontal
            }
            
            $0.collectionViewLayout = flowLayout
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            $0.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: FriendCollectionViewCell.cellIdentifier)
            
        }
        
        let separatorLine = UIView().then{
            $0.backgroundColor = Color.grey2
        }
        
        override func hierarchy() {
            
            super.hierarchy()
            
            self.baseView.addSubview(collectionView)
            self.baseView.addSubview(separatorLine)
        }
        
        override func layout() {
            
            super.layout()
            
            collectionView.snp.makeConstraints{
                $0.height.equalTo(86)
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-1)
            }
            
            separatorLine.snp.makeConstraints{
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
