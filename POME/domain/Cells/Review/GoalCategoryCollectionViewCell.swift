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
        $0.text = " "
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    func setSelectState(){
        goalCategoryView.backgroundColor = Color.mint100
        goalCategoryLabel.textColor = .white
        self.isUserInteractionEnabled = true
    }
    
    func setUnselectState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey5
        self.isUserInteractionEnabled = true
    }
    
    func setInactivateState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey3
        self.isUserInteractionEnabled = false
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
