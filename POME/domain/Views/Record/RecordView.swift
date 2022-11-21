//
//  Record.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//

import Foundation
import UIKit

class RecordView: BaseView {
    let goalCategoryView = UIView().then{
        $0.backgroundColor = .white
    }
    let goalPlusButton = UIButton().then{
        $0.setImage(Image.goalPlus, for: .normal)
    }
    var goalCollectionView: UICollectionView!
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
        
        setUpGoalCollectionView()
        setTableView()
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(goalCategoryView)
        goalCategoryView.addSubview(goalPlusButton)
        goalCategoryView.addSubview(goalCollectionView)
        
        addSubview(recordTableView)
        
        addSubview(writeButton)
    }
    
    override func layout() {
        super.layout()
        
        goalCategoryView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(41)
        }
        goalPlusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(52)
            make.height.equalTo(29)
            make.centerY.equalToSuperview()
        }
        goalCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(goalPlusButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(goalPlusButton)
        }
        recordTableView.snp.makeConstraints { make in
            make.top.equalTo(goalCategoryView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(super.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func setUpGoalCollectionView() {
        goalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            let flowLayout = UICollectionViewFlowLayout().then{
                $0.minimumLineSpacing = 8
                $0.minimumInteritemSpacing = 8
                $0.scrollDirection = .horizontal
            }
            
            $0.collectionViewLayout = flowLayout
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            $0.backgroundColor = Color.transparent
            
            $0.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: GoalCollectionViewCell.cellIdentifier)
        }
    }
    func setTableView() {
        recordTableView = UITableView().then{
            $0.register(EmptyGoalTableViewCell.self, forCellReuseIdentifier: "GoalTableViewCell")
            $0.register(GoEmotionBannerTableViewCell.self, forCellReuseIdentifier: "GoEmotionBannerTableViewCell")
            
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
