//
//  FriendCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class FriendCollectionViewCell: BaseCollectionViewCell {

    //MARK: - Properties
    static let cellIdentifier = "FriendCollectionViewCell"
    
    //MARK: - UI
    let profileImage = UIImageView().then{
        $0.image = Image.photoDefault
    }
    
    let nameLabel = UILabel().then{
        $0.text = "연지뉘"
        $0.font = UIFont.autoPretendard(type: .m_12)
        $0.textColor = Color.grey_5
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    override func hierarchy() {
        super.hierarchy()
        
        self.baseView.addSubview(profileImage)
        self.baseView.addSubview(nameLabel)
    }
    
    override func layout() {
        super.layout()
        
        profileImage.snp.makeConstraints{
            $0.width.height.equalTo(52)
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(6)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
