//
//  ReviewView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewView: BaseView{
    
    let tableView = UITableView().then{
        
        $0.backgroundColor = Color.transparent
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 74, right: 0)
        $0.backgroundView = ReviewEmptyView()
        
        $0.register(cellType: GoalTagsTableViewCell.self)
        $0.register(cellType: GoalDetailTableViewCell.self)
        $0.register(cellType: ReviewFilterTableViewCell.self)
        $0.register(cellType: ConsumeReviewTableViewCell.self)
        $0.register(cellType: LoadingTableViewCell.self)
    }
    
    override func hierarchy() {
        self.addSubview(tableView)
    }

    override func layout() {
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.backgroundView?.snp.makeConstraints{
            $0.top.equalToSuperview().offset(380)
            $0.centerX.equalToSuperview()
        }
    }
    
    func emptyViewWillShow(){
        tableView.backgroundView?.isHidden = false
    }
    
    func emptyViewWillHide(){
        tableView.backgroundView?.isHidden = true
    }
}

