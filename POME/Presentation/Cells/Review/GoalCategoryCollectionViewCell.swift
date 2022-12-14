//
//  GoalCategoryCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class GoalCategoryCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    static let cellIdentifier = "GoalCategoryCollectionViewCell"
    
    let goalCategoryView = UIView().then{
        $0.layer.cornerRadius = 30 / 2
    }
    
    let goalCategoryLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUnselectState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {self.setSelectState()}
//            else {self.setUnselectState()}
//        }
//    }
    
    //MARK: - Method
    
    func setSelectState(){
        goalCategoryView.backgroundColor = Color.mint100
        goalCategoryLabel.textColor = .white
    }
    
    func setUnselectState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey5
    }
    
    func setInactivateState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey3
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.baseView.addSubview(goalCategoryView)
        
        goalCategoryView.addSubview(goalCategoryLabel)
    }
    
    override func layout() {
        
        super.layout()
        
        goalCategoryView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        goalCategoryLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(12)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
