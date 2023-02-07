//
//  RecordCardTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit
import SnapKit

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
    let viewMoreButton = UIButton().then{
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .body2)
        $0.setTitleColor(Color.grey6, for: .normal)
        $0.isHidden = true
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
        
        backView.addSubview(viewMoreButton)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
            make.height.greaterThanOrEqualTo(182)
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
        dateLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        menuButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-14)
        }
        viewMoreButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(menuButton.snp.top).offset(-16)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.bottom.equalTo(viewMoreButton.snp.top).offset(-6)
        }
    }
    func setUpData(_ data: RecordResponseModel) {
        let content = data.useComment
        
        priceLabel.text = data.priceBinding
        
        contentLabel.text = content
        // 2줄이 넘어가면 더보기 버튼 보이게
        viewMoreButton.isHidden = contentLabel.countCurrentLines() > 2 ? false : true
        
        dateLabel.text = data.timeBinding.components(separatedBy: ["·"]).joined()
        
        
        firstEmotion.setTagInfo(when: .first, state: data.firstEmotionBinding)
        nextEmotion.setTagInfo(when: .second, state: data.secondEmotionBinding)
    }
    // MARK: 클릭 상태에 따라 텍스트 줄 수 제한
    func settingHeight(isClicked: ExpandingTableViewCellContent) {
        if isClicked.expanded == true {
            self.contentLabel.numberOfLines = 0
            viewMoreButton.isHidden = true
            viewMoreButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            self.contentLabel.numberOfLines = 2
            viewMoreButton.isHidden = contentLabel.countCurrentLines() > 2 ? false : true
        }
    }
}
// MARK: - Dynamic Cell Height Class
class ExpandingTableViewCellContent {
    var expanded: Bool

    init() {
        self.expanded = false
    }
}
