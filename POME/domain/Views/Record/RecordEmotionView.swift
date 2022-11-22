//
//  RecordEmotionView.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import Foundation

class RecordEmotionView: BaseView {
    var recordEmotionTableView: UITableView!
    
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
        
        addSubview(recordEmotionTableView)
    }
    
    override func layout() {
        super.layout()
        
        recordEmotionTableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    func setTableView() {
        recordEmotionTableView = UITableView().then{
            $0.register(RecordEmotionTableViewCell.self, forCellReuseIdentifier: "RecordEmotionTableViewCell")
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

