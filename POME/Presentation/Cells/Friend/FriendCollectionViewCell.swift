//
//  FriendCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class FriendCollectionViewCell: BaseCollectionViewCell {

    //MARK: - Properties
    static let cellSize = CGSize(width: 48, height: 86)
    
    //MARK: - UI
    let profileImage = UIImageView().then{
        $0.image = Image.photoDefault
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 48/2
        $0.contentMode = .scaleAspectFill
    }
    
    let nameLabel = UILabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }

    //MARK: - Override
    
    override func hierarchy() {
        super.hierarchy()
        baseView.addSubview(profileImage)
        baseView.addSubview(nameLabel)
    }
    
    override func layout() {
        
        super.layout()
        
        profileImage.snp.makeConstraints{
            $0.width.height.equalTo(48)
            $0.top.equalToSuperview().offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        nameLabel.textColor = Color.grey5
        profileImage.image = Image.photoDefault
    }
    
    //MARK: - Method

    func setSelectState(row: Int){
        nameLabel.textColor = Color.title
        if row == 0 {
            profileImage.image = Image.categoryActive
        }
    }
    
    func setUnselectState(row: Int){
        nameLabel.textColor = Color.grey5
        if row == 0 {
            profileImage.image = Image.categoryInactive
        }
    }
    
}
