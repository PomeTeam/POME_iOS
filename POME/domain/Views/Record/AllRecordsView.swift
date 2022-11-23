//
//  AllRecordsView.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import Foundation
import UIKit

class AllRecordsView: BaseView {
    let titleLabel = UILabel().then{
        $0.text = "모든 기록"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let subtitleLabel = UILabel().then{
        $0.text = "목표를 종료하기 전에 기록을 돌아보세요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    
    let goalView = GoalView(true, "end", "커피 대신 물을 마시자", "100,000원", "0원", 0)
    
    let countLabel = UILabel().then{
        $0.text = "전체 0건"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    
    var allRecordsTableView: UITableView!
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    override func style() {
        super.style()
        
        setTableView()
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(goalView)
        addSubview(countLabel)
        
        addSubview(allRecordsTableView)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
        }
        goalView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(157)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(goalView.snp.bottom).offset(20)
            make.leading.equalTo(goalView)
        }
        allRecordsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(countLabel.snp.bottom).offset(9)
        }
    }
    func setTableView() {
        allRecordsTableView = UITableView().then{
            // 기록 카드
            $0.register(RecordCardTableViewCell.self, forCellReuseIdentifier: "RecordCardTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
