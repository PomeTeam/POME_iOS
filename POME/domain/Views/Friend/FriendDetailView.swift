//
//  FriendDetailView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit


class FriendDetailView: BaseView {
    
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
        $0.text = "320,800원"
        $0.textColor = Color.title
        $0.setTypoStyle(typoStyle: .title3)
    }
    let memoLabel = UILabel().then{
        $0.text = "아휴 힘빠져 이젠 진짜 포기다 포기 도대체 뭐가 문제일까 현실을 되돌아볼 필요를 느낀다ㅠ 이정도 노력했으면 된거 아닌가 진짜 개 힘빠지네 그래서 오늘은 물 대신 라떼 한잔을 마셨습니다 ㅋ 라뗴 존맛탱~~ 다들 나흐바 시그니쳐 커피를 마셔주세요 설탕 솔솔 뿌려서 개맛있음"
        $0.textColor = Color.title
        $0.setTypoStyle(typoStyle: .body2)
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
        $0.text = " "
        $0.setTypoStyle(typoStyle: .subtitle3)
        $0.textColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    lazy var moreButton = UIButton().then{
        $0.setImage(Image.more, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    func setOthersReaction(count: Int){
        
        if(count == 0){
            //TODO: 0개일 때 어떤 이모지 사용...?
            othersReactionButton.setImage(Image.emojiAdd, for: .normal)
            return
        }else if(count == 1){
            othersReactionButton.setImage(Image.emojiHappy, for: .normal)
            return
        }
        
        //count > 1인 경우 아래 코드 실행
        self.othersReactionButton.addSubview(othersReactionCountLabel)

        othersReactionCountLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(6)
            $0.centerX.centerY.equalToSuperview()
        }
        
        let countString: String!
        
        if(count < 10){
            countString = "+\(count)"
        }else{
            countString = "9+"
        }
        
        othersReactionCountLabel.text = countString
        othersReactionButton.setImage(Image.emojiBlurSad, for: .normal)
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
        topStackView.addArrangedSubview(tagLabel)
        topStackView.addArrangedSubview(timeLabel)
        
        emotionStackView.addArrangedSubview(firstEmotionTag)
        emotionStackView.addArrangedSubview(tagArrowBackgroundView)
        tagArrowBackgroundView.addSubview(tagArrowImage)
        emotionStackView.addArrangedSubview(secondEmotionTag)

        reactionStackView.insertArrangedSubview(othersReactionButton, at: 0)
        reactionStackView.insertArrangedSubview(myReactionBtn, at: 0)
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
        
        moreButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(reactionStackView)
            $0.width.equalTo(23)
            $0.height.equalTo(22)
        }
    }
}
