//
//  FriendTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class FriendTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties

    static let cellIdentifier = "FriendTableViewCell"
    
    //MARK: - UI
    
    let profileImage = UIImageView().then{
        $0.backgroundColor = Color.grey_4
    }
    
    let nameLabel = UILabel().then{
        $0.text = "eunjoeme_xx"
        $0.font = UIFont.autoPretendard(type: .m_14)
        $0.textColor = Color.grey_6
    }
    let priceLabel = UILabel().then{
        $0.text = "320,800원"
        $0.font = UIFont.autoPretendard(type: .sb_18)
        $0.textColor = Color.grey_9
    }
    let memoLabel = UILabel().then{
        $0.text = "여기에 멀 치면 어케 나오나요 대박킼"
        $0.numberOfLines = 2
        $0.font = UIFont.autoPretendard(type: .m_14)
        $0.textColor = Color.grey_8
    }
    let tagLabel = PaddingLabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.font = UIFont.autoPretendard(type: .m_12)
        $0.textColor = Color.grey_5
        $0.backgroundColor = Color.grey_1
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    let timeLabel = UILabel().then{
        $0.text = " 1시간 전"
        $0.font = UIFont.autoPretendard(type: .m_12)
        $0.textColor = Color.grey_5
    }
    
    let emojiStackView = UIStackView().then{
        $0.spacing = -6
        $0.axis = .horizontal
    }
    
    let greenEmojiImage = UIImageView().then{
        $0.backgroundColor = Color.main
    }
    
    let pinkEmojiImage = UIImageView().then{
        $0.backgroundColor = Color.sub
    }
    
    let reactionStackView = UIStackView().then{
        $0.spacing = -6
        $0.axis = .horizontal
    }
    
    lazy var myReactionBtn = UIButton().then{
        $0.backgroundColor = Color.main
    }
    
    lazy var anotherReactionBtn = UIButton().then{
        $0.backgroundColor = Color.sub
    }
    
    lazy var theOtherReactionBtn = UIButton().then{
        $0.backgroundColor = Color.grey_4
    }
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    override func setting() {
        super.setting()
        
        self.baseView.layer.cornerRadius = 8
        self.baseView.setShadowStyle(type: .friendCard)
    }
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.baseView.addSubview(profileImage)
        
        self.baseView.addSubview(nameLabel)
        self.baseView.addSubview(priceLabel)
        self.baseView.addSubview(memoLabel)
        self.baseView.addSubview(tagLabel)
        
        self.baseView.addSubview(timeLabel)
        self.baseView.addSubview(emojiStackView)
        self.baseView.addSubview(reactionStackView)
        
        emojiStackView.insertArrangedSubview(pinkEmojiImage, at: 0)
        emojiStackView.insertArrangedSubview(greenEmojiImage, at: 0)

        reactionStackView.insertArrangedSubview(theOtherReactionBtn, at: 0)
        reactionStackView.insertArrangedSubview(anotherReactionBtn, at: 0)
        reactionStackView.insertArrangedSubview(myReactionBtn, at: 0)
    }
    
    override func layout() {

        self.baseView.snp.remakeConstraints{
            $0.height.equalTo(161 + 14)
            $0.top.equalToSuperview().offset(7)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel)
        }
        
        memoLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().offset(-126)
            $0.height.equalTo(37)
        }
        
        tagLabel.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        emojiStackView.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(14)
            $0.trailing.equalTo(timeLabel)
        }
        
        greenEmojiImage.snp.makeConstraints{
            $0.width.height.equalTo(34)
        }
        
        pinkEmojiImage.snp.makeConstraints{
            $0.width.height.equalTo(34)
        }
        
        reactionStackView.snp.makeConstraints{
            $0.top.equalTo(emojiStackView.snp.bottom).offset(31)
            $0.trailing.equalTo(timeLabel)
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        myReactionBtn.snp.makeConstraints{
            $0.width.height.equalTo(28)
        }
        
        anotherReactionBtn.snp.makeConstraints{
            $0.width.height.equalTo(myReactionBtn)
        }
        
        theOtherReactionBtn.snp.makeConstraints{
            $0.width.height.equalTo(myReactionBtn)
        }
    }

}
