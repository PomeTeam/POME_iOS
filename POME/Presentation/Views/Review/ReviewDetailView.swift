//
//  ReviewDetailView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewDetailView: BaseView {
    
    private var record: RecordResponseModel!
    
    //MARK: - Properties
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
    
    let priceLabel = UILabel().then{
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    let memoLabel = UILabel().then{
        $0.textColor = Color.title
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
        $0.numberOfLines = 0
    }

    let etcStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    let tagLabel = UILabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
    }
    let timeLabel = UILabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
    }
    
    let reactionStackView = UIStackView().then{
        $0.spacing = -6
        $0.axis = .horizontal
    }
    lazy var leftReactionButton = UIButton().then{
        $0.setImage(Image.emojiAdd, for: .normal)
    }
    lazy var rightReactionButton = UIButton()
    lazy var rightReactionCountLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
    }
    lazy var moreButton = UIButton().then{
        $0.setImage(Image.moreHorizontal, for: .normal)
    }
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.addSubview(emotionStackView)
        self.addSubview(priceLabel)
        self.addSubview(memoLabel)
        self.addSubview(etcStackView)
        self.addSubview(reactionStackView)
        self.addSubview(moreButton)
        
        etcStackView.addArrangedSubview(tagLabel)
        etcStackView.addArrangedSubview(timeLabel)
        
        emotionStackView.addArrangedSubview(firstEmotionTag)
        emotionStackView.addArrangedSubview(tagArrowBackgroundView)
        emotionStackView.addArrangedSubview(secondEmotionTag)
        
        tagArrowBackgroundView.addSubview(tagArrowImage)

        reactionStackView.insertArrangedSubview(rightReactionButton, at: 0)
        reactionStackView.insertArrangedSubview(leftReactionButton, at: 0)
        
        rightReactionButton.addSubview(rightReactionCountLabel)
    }

    override func layout() {
        
        super.layout()
    
        emotionStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
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
        
        //
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
        
        etcStackView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.equalTo(memoLabel.snp.bottom).offset(16)
//            $0.height.equalTo(nameLabel.font.lineHeight) //14
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        reactionStackView.snp.makeConstraints{
            $0.top.equalTo(etcStackView.snp.bottom).offset(16)
            $0.height.equalTo(28)
            $0.leading.bottom.equalToSuperview()
        }
        
        leftReactionButton.snp.makeConstraints{
            $0.width.height.equalTo(28)
        }
        
        rightReactionButton.snp.makeConstraints{
            $0.width.height.equalTo(28)
        }
        rightReactionCountLabel.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(reactionStackView)
            $0.width.equalTo(23)
            $0.height.equalTo(22)
        }
    }
    //MARK: - Method
    
    func dataBinding(with record: RecordResponseModel){

        self.record = record
        
        tagLabel.text = record.oneLineMind
        timeLabel.text = record.timeBinding
        priceLabel.text = record.priceBinding
        memoLabel.text = record.useComment
        
        firstEmotionTag.setTagInfo(when: .first, state: record.firstEmotionBinding)
        secondEmotionTag.setTagInfo(when: .second, state: record.secondEmotionBinding)

        if(record.othersReactionCountBinding == 0){
            setFriendsReactionEmpty()
        }else if(record.othersReactionCountBinding == 1){
            setFriendsReactionCountOne()
        }else{
            setFriendsReactionWithCountLabel()
        }
    }
    
    private func setFriendsReactionEmpty(){
        leftReactionButton.setImage(.none, for: .normal)
        rightReactionButton.setImage(.none, for: .normal)
    }
    
    private func setFriendsReactionCountOne(){
        leftReactionButton.setImage(record.firstFriendReaction.defaultImage, for: .normal)
        rightReactionButton.setImage(.none, for: .normal)
    }
    
    private func setFriendsReactionWithCountLabel(){
        leftReactionButton.setImage(record.firstFriendReaction.defaultImage, for: .normal)
        rightReactionButton.setImage(record.secondFriendReaction.blurImage, for: .normal)
        setReactionCount()
    }
    
    private func setReactionCount(){
        let count = record.othersReactionCountBindingInReview
        rightReactionCountLabel.isHidden = false
        rightReactionCountLabel.text = count < 10 ? "+\(count)" : "+\(9)"
    }
}
