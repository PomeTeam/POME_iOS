//
//  MarshmallowCollectionViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class MarshmallowCollectionViewCell: BaseCollectionViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.setShadowStyle(type: .card)
    }
    let levelStack = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 6
    }
    let levelIcon = PaddingLabel(padding: UIEdgeInsets(top: 6, left: 2.5, bottom: 6, right: 2.5)).then{
        $0.setLevelIcon(1)
    }
    let levelLabel = PaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)).then{
        $0.setLevelLabel(.record, 1)
    }
    let marshmallowImg = UIImageView().then{
        $0.image = Image.marshmallowLevel1Pink
    }
    
    //MARK: - LifeCycle
    static let cellIdentifier = "MarshmallowCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Override
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        
        backView.addSubview(levelStack)
        levelStack.addArrangedSubview(levelIcon)
        levelStack.addArrangedSubview(levelLabel)
        
        backView.addSubview(marshmallowImg)
    }
    
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        levelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        levelIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        marshmallowImg.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.top.equalTo(levelStack.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: set API
    func setUpMarshmallow(_ type: MarshmallowType, _ level: Int) {
        self.marshmallowImg.setMarshmallowImage(type, level)
        self.levelIcon.setLevelIcon(level)
        self.levelLabel.setLevelLabel(type, level)
    }
}


enum MarshmallowType {
    case record
    case emotion
    case growth
    case honest
}
