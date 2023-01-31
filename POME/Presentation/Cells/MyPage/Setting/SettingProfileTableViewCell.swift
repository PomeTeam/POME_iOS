//
//  SettingProfileTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class SettingProfileTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
    }
    let profileImg = UIImageView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = Color.pink10
        $0.contentMode = .scaleAspectFill
    }
    let profileName = UILabel().then{
        $0.text = "포포"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.title
    }
    let separatorView = UIView().then{
        $0.backgroundColor = Color.grey0
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
        
        self.contentView.backgroundColor = .white
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        backView.addSubview(profileImg)
        backView.addSubview(profileName)
        
        self.contentView.addSubview(separatorView)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(59)
        }
        profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        profileName.snp.makeConstraints { make in
            make.leading.equalTo(profileImg.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backView.snp.bottom)
            make.height.equalTo(12)
        }
    }
    func setUpData() {
        let nickName = UserManager.nickName ?? ""
        let imageUrl = UserManager.profileImg ?? ""
        let imageServer = "https://2023-pome-buket.s3.ap-northeast-2.amazonaws.com/"
        
        profileName.text = nickName
        if imageUrl != "default" {
            profileImg.kf.setImage(with: URL(string: imageServer + imageUrl), placeholder: Image.photoDefault)
        }
    }
}
