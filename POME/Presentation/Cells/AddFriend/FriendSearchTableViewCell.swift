//
//  FriendSearchTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit

class FriendSearchTableViewCell: BaseTableViewCell {
    let rightButton = UIButton().then{
        $0.setImage(Image.plus, for: .normal)
        $0.setImage(Image.addComplete, for: .selected)
    }
    let profileImg = UIImageView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
        $0.backgroundColor = Color.pink30
    }
    let profileName = UILabel().then{
        $0.text = "고민"
        $0.font = UIFont.autoPretendard(type: .m_16)
        $0.textColor = Color.title
    }

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
        
//        rightButton.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(profileImg)
        self.contentView.addSubview(profileName)
        self.contentView.addSubview(rightButton)
    }
    override func layout() {
        super.layout()
        
        profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        profileName.snp.makeConstraints { make in
            make.leading.equalTo(profileImg.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
        }
    }
}
