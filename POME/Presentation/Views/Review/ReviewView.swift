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
        
        $0.register(GoalTagsTableViewCell.self, forCellReuseIdentifier: GoalTagsTableViewCell.cellIdentifier)
        $0.register(GoalDetailTableViewCell.self, forCellReuseIdentifier: GoalDetailTableViewCell.cellIdentifier)
        $0.register(ReviewFilterTableViewCell.self, forCellReuseIdentifier: ReviewFilterTableViewCell.cellIdentifier)
        $0.register(ConsumeReviewTableViewCell.self, forCellReuseIdentifier: ConsumeReviewTableViewCell.cellIdentifier)
    }
    
    override func hierarchy() {
        self.addSubview(tableView)
    }
    
    override func layout() {
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
