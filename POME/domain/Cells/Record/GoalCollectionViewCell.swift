//
//  GoalCollectionViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//
import UIKit

class GoalCollectionViewCell: BaseCollectionViewCell {
    let backView = UIView().then{
        $0.backgroundColor = Color.mint100
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15.5
    }
    let goalTitleLabel = UILabel().then{
        $0.font = UIFont.autoPretendard(type: .sb_14)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    static let cellIdentifier = "GoalCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    override func style() {
        if self.isSelected {
            backView.backgroundColor = Color.mint100
            goalTitleLabel.textColor = .white
        } else {
            backView.backgroundColor = Color.grey0
            goalTitleLabel.textColor = Color.grey5
        }
    }
    
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        backView.addSubview(goalTitleLabel)
//        self.baseView.addSubview(profileImage)
//        self.baseView.addSubview(nameLabel)
    }
    
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        goalTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
