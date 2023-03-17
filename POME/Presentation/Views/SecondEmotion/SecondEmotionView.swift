//
//  SecondEmotionView.swift
//  POME
//
//  Created by gomin on 2022/11/26.
//

import Foundation
import UIKit

class SecondEmotionView: BaseView {
    // MARK: - Views
    let titleLabel = UILabel().then{
        $0.text = "일주일이 지난 오늘의\n솔직한 감정을 남겨주세요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .title1)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "포미는 순간의 감정에 집중해\n한번 기록된 감정은 바꿀 수 없어요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let emojiStack = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = Device.isSmallDevice ? 32 : 40
    }
    let happyEmoji = SecondEmoji(Image.reviewHappy, "행복해요")
    let whatEmoji = SecondEmoji(Image.reviewWhat, "모르겠어요")
    let sadEmoji = SecondEmoji(Image.reviewSad, "후회해요")
    
    let completeButton = DefaultButton(titleStr: "남겼어요").then{
        $0.inactivateButton()
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    override func style() {
        super.style()
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        addSubview(emojiStack)
        emojiStack.addArrangedSubview(happyEmoji)
        emojiStack.addArrangedSubview(whatEmoji)
        emojiStack.addArrangedSubview(sadEmoji)
        
        addSubview(completeButton)
    }
    
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        emojiStack.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(41)
            make.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-34)
            make.height.equalTo(52)
        }
    }
}

// MARK: - 두번째 감정 Stack
class SecondEmoji: UIStackView {
    let imgBackView = UIView().then{
        $0.backgroundColor = Color.grey0
        
        let imageSize: CGFloat = Device.isSmallDevice ? 90 : 110
        $0.layer.cornerRadius = imageSize / 2
    }
    let emojiImage = UIImageView().then{
        $0.image = Image.reviewHappy
    }
    let emoLabel = UILabel().then{
        $0.text = "행복해요"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.body
    }
    
    // MARK: Life Cycle
    var isSelected: Bool = false {
        didSet {
            if isSelected {setSelected()}
            else {setUnselected()}
        }
    }
    
    init(_ emojiImg: UIImage, _ emotionStr: String) {
        super.init(frame: CGRect.zero)
        
        self.axis = .horizontal
        self.spacing = 15
        
        emojiImage.image = emojiImg
        emoLabel.text = emotionStr
        
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("SecondEmoji: init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setLayout() {
        self.addArrangedSubview(imgBackView)
        imgBackView.addSubview(emojiImage)
        self.addArrangedSubview(emoLabel)
        
        imgBackView.snp.makeConstraints { make in
            let size = Device.isSmallDevice ? 90 : 110
            make.width.height.equalTo(size)
        }
        emojiImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(21)
            make.centerX.centerY.equalToSuperview()
        }
    }
    func setSelected() {
        imgBackView.backgroundColor = Color.pink10
        emoLabel.textColor = Color.pink100
    }
    func setUnselected() {
        imgBackView.backgroundColor = Color.grey0
        emoLabel.textColor = Color.body
    }
    
    
}
