//
//  ReviewDetailView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewDetailView: BaseView {
    
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
    
    //
    let priceLabel = UILabel().then{
        $0.text = "320,800원"
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    let memoLabel = UILabel().then{
        $0.text = "아휴 힘빠져 이젠 진짜 포기다 포기 도대체 뭐가 문제일까 현실을 되돌아볼 필요를 느낀다ㅠ 이정도 노력했으면 된거 아닌가 진짜 개 힘빠지네 그래서 오늘은 물 대신 라떼 한잔을 마셨습니다 ㅋ 라뗴 존맛탱~~ 다들 나흐바 시그니쳐 커피를 마셔주세요 설탕 솔솔 뿌려서 개맛있음"
        $0.textColor = Color.title
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
        $0.numberOfLines = 0
    }
    
    //
    
    let etcStackView = UIStackView().then{
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let tagLabel = PaddingLabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
    }
    
    let timeLabel = UILabel().then{
        $0.text = "· 44분 전"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
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
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle3)
        $0.textColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    lazy var moreButton = UIButton().then{
        $0.setImage(Image.moreHorizontal, for: .normal)
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        reactionStackView.insertArrangedSubview(othersReactionButton, at: 0)
        reactionStackView.insertArrangedSubview(myReactionBtn, at: 0)
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
