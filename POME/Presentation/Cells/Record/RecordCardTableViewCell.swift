//
//  RecordCardTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class RecordCardTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.setShadowStyle(type: .card)
    }
    let firstEmotion = EmotionTagView()
    let nextEmotion = EmotionTagView()
    let arrowImage = UIImageView().then{
        $0.image = Image.rightArrowGray
    }
    let priceLabel = UILabel().then{
        $0.text = "16,000원"
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = Color.title
    }
    let contentLabel = UILabel().then{
        $0.text = "아휴 힘빠져 이젠 진짜 포기다 포기 도대체 뭐가 문제일까 현실을 되돌아볼 필요를 느낀다ㅠ 이정도 노력했으면 된거아"
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
        $0.textColor = Color.body
        $0.numberOfLines = 2
    }
    let dateLabel = UILabel().then{
        $0.text = "6월 24일"
        $0.setTypoStyleWithSingleLine(typoStyle: .body3)
        $0.textColor = Color.grey5
    }
    let menuButton = UIButton().then{
        $0.setImage(Image.moreHorizontal, for: .normal)
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
        
        self.contentView.addSubview(backView)
        
        backView.addSubview(firstEmotion)
        backView.addSubview(arrowImage)
        backView.addSubview(nextEmotion)
        
        backView.addSubview(priceLabel)
        backView.addSubview(contentLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(menuButton)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
            make.height.equalTo(182)
        }
        firstEmotion.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        arrowImage.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.leading.equalTo(firstEmotion.snp.trailing).offset(2)
            make.centerY.equalTo(firstEmotion)
        }
        nextEmotion.snp.makeConstraints { make in
            make.leading.equalTo(arrowImage.snp.trailing).offset(2)
            make.top.equalTo(firstEmotion)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(firstEmotion.snp.bottom).offset(14)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        menuButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-14)
        }
    }
    func setUpData(_ data: RecordResponseModel) {
        let price = data.usePrice
        let content = data.useComment
        
        // 가격 콤마 표시
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: price)) ?? ""
        priceLabel.text = result + "원"
        
        contentLabel.text = content
        dateLabel.text = data.timeBinding.components(separatedBy: ["·"]).joined()
        
        
        firstEmotion.setTagInfo(when: .first, state: data.firstEmotionBinding)
        nextEmotion.setTagInfo(when: .second, state: data.secondEmotionBinding)
    }
}
