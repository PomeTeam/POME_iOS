//
//  MypageProfileTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class MypageProfileTableViewCell: BaseTableViewCell {
    let profileImg = UIImageView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 39
        $0.backgroundColor = Color.pink10
    }
    let profileName = UILabel().then{
        $0.text = "포포"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle1)
        $0.textColor = Color.grey9
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
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(profileImg)
        self.contentView.addSubview(profileName)
    }
    override func layout() {
        super.layout()
        
        profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(78)
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
        }
        profileName.snp.makeConstraints { make in
            make.top.equalTo(profileImg.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }

}
