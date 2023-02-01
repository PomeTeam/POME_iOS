//
//  FriendSearchTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit
import Kingfisher

class FriendSearchTableViewCell: BaseTableViewCell {
    let rightButton = UIButton().then{
        $0.setImage(Image.plus, for: .normal)
        $0.setImage(Image.addComplete, for: .selected)
    }
    let profileImg = UIImageView().then{
        $0.image = Image.photoDefault
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
        $0.contentMode = .scaleAspectFill
    }
    let profileName = UILabel().then{
        $0.text = "고민"
        $0.font = UIFont.autoPretendard(type: .m_16)
        $0.textColor = Color.title
    }

    //MARK: - LifeCycle
    var friendName: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
//        self.rightButton.isSelected = false
        self.profileName.text = ""
        self.profileImg.image = Image.photoDefault
    }
    // MARK: - Methods
    override func setting() {
        super.setting()
        
        
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
    // After API
    func setUpData(_ data: FriendsResponseModel, _ isFriendSearch: Bool) {
        let friendId = data.friendUserId
        self.friendName = data.friendNickName
        let imageURL = data.imageKey
        let isFriend = data.friend
        
        profileName.text = self.friendName
        rightButton.isSelected = isFriend ? true : false
        
        if imageURL != "default" {
            profileImg.kf.setImage(with: URL(string: imageURL), placeholder: Image.photoDefault)
        }
        
        if isFriendSearch {
            rightButton.addTarget(self, action: #selector(plusFriendButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    @objc func plusFriendButtonDidTap(_ sender: UIButton) {
        let btn = sender
        if !(btn.isSelected) {
            btn.isSelected = true
            generateNewFriend(id: self.friendName)
        }
    }
    private func generateNewFriend(id: String){
        FriendService.shared.generateNewFriend(id: id) { result in
            print("\(id) - 친구 추가")
        }
    }
}
