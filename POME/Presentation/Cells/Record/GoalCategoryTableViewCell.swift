//
//  GoalCollectionViewTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class GoalCategoryTableViewCell: BaseTableViewCell {
    let goalPlusButton = UIButton().then{
        $0.setImage(Image.goalPlus, for: .normal)
    }
    var goalCollectionView: UICollectionView!

    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func setting() {
        super.setting()
        
        setUpGoalCollectionView()
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(goalPlusButton)
        self.contentView.addSubview(goalCollectionView)
    }
    override func layout() {
        super.layout()
        
        goalPlusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(52)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        goalCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(goalPlusButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(goalPlusButton)
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
            
            $0.register(GoalTagCollectionViewCell.self, forCellWithReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier)
        }
    }
}
