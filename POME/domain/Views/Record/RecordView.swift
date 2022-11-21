//
//  Record.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//

import Foundation
import UIKit

class RecordView: BaseView {
    var recordTableView: UITableView!
    
    let writeButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.writingBtn
        config.background.backgroundColor = .red
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.configuration = config
    }
    
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
        
        addSubview(recordTableView)
        addSubview(writeButton)
    }
    
    override func layout() {
        super.layout()
        
        recordTableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(super.safeAreaLayoutGuide).offset(-16)
        }
    }
    func setTableView() {
        recordTableView = UITableView().then{
            $0.register(GoalCollectionViewTableViewCell.self, forCellReuseIdentifier: "GoalCollectionViewTableViewCell")
            $0.register(EmptyGoalTableViewCell.self, forCellReuseIdentifier: "GoalTableViewCell")
            $0.register(GoEmotionBannerTableViewCell.self, forCellReuseIdentifier: "GoEmotionBannerTableViewCell")
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
