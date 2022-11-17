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
    
    var delegate: CellDelegate?
    
    //MARK: - UI
    
    let marginView = UIView()
    
    let profileImage = UIImageView().then{
        $0.backgroundColor = Color.grey4
    }
    
    //user stackView
    
    let topStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let nameLabel = UILabel().then{
        $0.text = "규렌버"
        $0.textColor = Color.body
        $0.setTypoStyle(typoStyle: .subtitle3)
    }
    
    let tagLabel = PaddingLabel().then{
        $0.text = "· 커피 대신 물을 마시자"
        $0.textColor = Color.grey5
        $0.setTypoStyle(typoStyle: .body3)
    }
    
    let timeLabel = UILabel().then{
        $0.text = "· 44분 전   "
        $0.textColor = Color.grey5
        $0.setTypoStyle(typoStyle: .body3)
    }

    let emotionStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let firstEmotionTag = UIImageView().then{
        $0.backgroundColor = Color.mint100
    }
    
    let reviewEmotionTag = UIImageView().then{
        $0.backgroundColor = Color.pink100
    }
    
    let tagArrowBackgroundView = UIView()
    
    let tagArrowImage = UIImageView().then{
        $0.image = Image.tagArrow
    }
    
    //
    let priceLabel = UILabel().then{
        $0.text = "320,800원"
        $0.textColor = Color.title
        $0.setTypoStyle(typoStyle: .title3)
    }
    let memoLabel = UILabel().then{
        $0.text = "아휴 힘빠져 이젠 진짜 포기다 포기 도대체 뭐가 문제일까 현실을 되돌아볼 필요를 느낀다ㅠ 이정도 노력했으···"
        $0.textColor = Color.title
        $0.setTypoStyle(typoStyle: .body2)
        $0.numberOfLines = 2
    }
    
    //
    let reactionStackView = UIStackView().then{
        $0.spacing = -6
        $0.axis = .horizontal
    }
    
    lazy var myReactionBtn = UIButton().then{
        $0.setImage(Image.emojiAdd, for: .normal)
        $0.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
    }
    
    lazy var othersReactionButton = UIButton().then{
        $0.setImage(Image.EmojiBlurFlex, for: .normal)
    }
    
    lazy var moreButton = UIButton().then{
        $0.setImage(Image.more, for: .normal)
    }
    
    //
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
        
    }
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    @objc func myReactionBtnDidClicked(){
        
        guard let index = getCellIndex() else { return }

        delegate?.sendCellIndex(indexPath: index)
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.baseView.addSubview(profileImage)
        self.baseView.addSubview(marginView)
        self.baseView.addSubview(separatorLine)
        
        marginView.addSubview(topStackView)
        marginView.addSubview(emotionStackView)
        marginView.addSubview(priceLabel)
        marginView.addSubview(memoLabel)
        marginView.addSubview(reactionStackView)
        marginView.addSubview(moreButton)
        
        topStackView.addArrangedSubview(nameLabel)
        topStackView.addArrangedSubview(tagLabel)
        topStackView.addArrangedSubview(timeLabel)
        
        emotionStackView.addArrangedSubview(firstEmotionTag)
        emotionStackView.addArrangedSubview(tagArrowBackgroundView)
        tagArrowBackgroundView.addSubview(tagArrowImage)
        emotionStackView.addArrangedSubview(reviewEmotionTag)

        reactionStackView.insertArrangedSubview(othersReactionButton, at: 0)
        reactionStackView.insertArrangedSubview(myReactionBtn, at: 0)
    }
    
    override func layout() {
        
        super.layout()

        profileImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(30)
        }
        
        marginView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        topStackView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(nameLabel.font.lineHeight) //14
            $0.trailing.lessThanOrEqualToSuperview()
        }
    
        emotionStackView.snp.makeConstraints{
            $0.top.equalTo(topStackView.snp.bottom).offset(8)
            $0.height.equalTo(26)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        firstEmotionTag.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        tagArrowBackgroundView.snp.makeConstraints{
            $0.width.equalTo(tagArrowImage)
        }
        
        tagArrowImage.snp.makeConstraints{
            $0.width.height.equalTo(12)
            $0.centerY.equalToSuperview()
        }
        
        reviewEmotionTag.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(emotionStackView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        memoLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        reactionStackView.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(16)
            $0.height.equalTo(28)
            $0.leading.bottom.equalToSuperview()
        }
        
        myReactionBtn.snp.makeConstraints{
            $0.width.height.equalTo(28)
        }
        
        othersReactionButton.snp.makeConstraints{
            $0.width.height.equalTo(myReactionBtn)
        }
        
        moreButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(reactionStackView)
            $0.width.equalTo(23)
            $0.height.equalTo(22)
        }
        
        separatorLine.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

}
