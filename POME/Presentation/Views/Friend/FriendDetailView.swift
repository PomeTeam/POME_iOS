//
//  FriendDetailView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit
import Kingfisher

class FriendDetailView: BaseView {
    
    //MARK: - UI
    
    let profileImageManager = FriendProfileImageManager.shared
    
    let marginView = UIView()
    
    let profileImage = UIImageView().then{
        $0.image = Image.photoDefault
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30/2
        $0.contentMode = .scaleAspectFill
    }
    
    //user stackView
    let topStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let nameLabel = UILabel().then{
        $0.textColor = Color.body
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
    }
    
    let goalPromiseLabel = PaddingLabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
    }
    
    let timeLabel = UILabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
    }

    //
    let emotionStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    var firstEmotionTag = EmotionTagView()
    
    var secondEmotionTag = EmotionTagView()
    
    let tagArrowBackgroundView = UIView()
    
    let tagArrowImage = UIImageView().then{
        $0.image = Image.tagArrow
    }
    
    //
    let priceLabel = UILabel().then{
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    let memoLabel = UILabel().then{
        $0.textColor = Color.title
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
        $0.numberOfLines = 0
    }
    
    //
    let reactionStackView = UIStackView().then{
        $0.spacing = -6
        $0.axis = .horizontal
    }
    
    lazy var myReactionBtn = UIButton().then{
        $0.setImage(Image.emojiAdd, for: .normal)
    }
    
    lazy var othersReactionButton = UIButton()
    
    lazy var othersReactionCountLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
    }
    
    lazy var moreButton = UIButton().then{
        $0.setImage(Image.moreHorizontal, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    func dataBinding(with record: RecordResponseModel){
        
        let imageUrl = profileImageManager.getProfileImage(nickname: record.nickname)
        
        profileImage.kf.setImage(with: URL(string: imageUrl), placeholder: Image.photoDefault)
        nameLabel.text = record.nickname
        goalPromiseLabel.text = record.friendGoalMindBinding
        timeLabel.text = record.timeBinding
        priceLabel.text = record.priceBinding
        memoLabel.text = record.useComment
        
        firstEmotionTag.setTagInfo(when: .first, state: record.firstEmotionBinding)
        secondEmotionTag.setTagInfo(when: .second, state: record.secondEmotionBinding)
        myReactionBtn.setImage(record.myReactionBinding, for: .normal)
        
        record.othersReactionCountBinding == 0 ? setOthersReactionEmpty() : setOthersReaction(thumbnail: record.othersThumbnailReactionBinding, count: record.othersReactionCountBinding)
    }
    
    func setOthersReactionEmpty(){
        othersReactionCountLabel.isHidden = true
        othersReactionButton.setImage(.none, for: .normal)
        othersReactionButton.isEnabled = false
    }
    
    func setOthersReaction(thumbnail: Reaction, count: Int){
        
        othersReactionCountLabel.isHidden = false
        othersReactionButton.isEnabled = true
        
        let countString: String!
        
        if(count < 10){
            countString = "+\(count)"
        }else{
            countString = "9+"
        }
        
        othersReactionCountLabel.text = countString
        othersReactionButton.setImage(thumbnail.blurImage, for: .normal)
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.addSubview(profileImage)
        self.addSubview(marginView)
        
        marginView.addSubview(topStackView)
        marginView.addSubview(emotionStackView)
        marginView.addSubview(priceLabel)
        marginView.addSubview(memoLabel)
        marginView.addSubview(reactionStackView)
        marginView.addSubview(moreButton)
        
        topStackView.addArrangedSubview(nameLabel)
        topStackView.addArrangedSubview(goalPromiseLabel)
        topStackView.addArrangedSubview(timeLabel)
        
        emotionStackView.addArrangedSubview(firstEmotionTag)
        emotionStackView.addArrangedSubview(tagArrowBackgroundView)
        tagArrowBackgroundView.addSubview(tagArrowImage)
        emotionStackView.addArrangedSubview(secondEmotionTag)

        reactionStackView.insertArrangedSubview(othersReactionButton, at: 0)
        reactionStackView.insertArrangedSubview(myReactionBtn, at: 0)
        
        othersReactionButton.addSubview(othersReactionCountLabel)
    }


    override func layout() {
        
        super.layout()

        profileImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        marginView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalTo(profileImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
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
        }
        
        tagArrowBackgroundView.snp.makeConstraints{
            $0.width.equalTo(tagArrowImage)
        }
        
        tagArrowImage.snp.makeConstraints{
            $0.width.height.equalTo(12)
            $0.centerY.equalToSuperview()
        }
        
        secondEmotionTag.snp.makeConstraints{
            $0.height.equalToSuperview()
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
            $0.width.height.equalTo(28)
        }
        othersReactionCountLabel.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
//            $0.leading.top.equalToSuperview().offset(6)
//            $0.centerX.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(reactionStackView)
            $0.width.equalTo(23)
            $0.height.equalTo(22)
        }
    }
}
