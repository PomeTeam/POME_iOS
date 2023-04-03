//
//  GoalCategoryCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class GoalTagCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    static let emptyTitle = "···"

    var title: String = ""{
        didSet{
            goalCategoryLabel.text = title
        }
    }
    
    private let goalCategoryLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textAlignment = .center
    }
    
    private let goalCategoryView = UIView().then{
        $0.layer.cornerRadius = 30 / 2
    }
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        goalCategoryLabel.text = ""
        goalCategoryLabel.textColor = .white
        setInactivateState()
    }
    
    //MARK: - Method
    
    func setSelectState(){
        goalCategoryView.backgroundColor = Color.mint100
        goalCategoryLabel.textColor = .white
    }
    
    func setUnselectState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey5
    }
    
    func setUnselectState(with isEnd: Bool){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = isEnd ? Color.grey3 : Color.grey5
    }
    
    func setInactivateState(){
        goalCategoryView.backgroundColor = .white
        goalCategoryLabel.textColor = Color.grey3
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        super.hierarchy()
        baseView.addSubview(goalCategoryView)
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
    
    static func estimatedSize(title: String) -> CGSize{
        let testLabel = UILabel().then{
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
            $0.textAlignment = .center
            $0.text = title
        }
        let width = testLabel.intrinsicContentSize.width + 12 * 2
        return CGSize(width: width, height: 30)
    }
}
