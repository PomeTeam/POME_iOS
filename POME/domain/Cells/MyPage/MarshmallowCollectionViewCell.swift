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
    let levelIcon = UIImageView().then{
        $0.image = Image.level4
    }
    let levelLabel = PaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)).then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.text = "기록말랑"
        $0.setTypoStyleWithSingleLine(typoStyle: .title5)
        $0.textColor = Color.pink100
        $0.backgroundColor = Color.pink30
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
    func setUpMarshmallow(_ level: Int, _ marshmallowImg: UIImage) {
        if level == 1 {
            levelIcon.image = Image.level1
            levelLabel.textColor = Color.grey5
            levelLabel.backgroundColor = Color.grey1
        }
        self.marshmallowImg.image = marshmallowImg
    }
}
