//
//  SelectEmotionView.swift
//  POME
//
//  Created by gomin on 2023/06/05.
//

import Foundation
import UIKit
import SnapKit

enum SelectEmotionType {
    case First
    case Second
}

class SelectEmotionView: BaseView {
    var titleView: RegisterCommonTitleView
    
    let emotionStackView = UIStackView().then{
        $0.spacing = Device.isSmallDevice ? 32 : 40
        $0.axis = .vertical
    }
    var happyEmotionView: EmotionElementView
    var whatEmotionView: EmotionElementView
    var sadEmotionView: EmotionElementView
    
    lazy var completeButton = DefaultButton(titleStr: "남겼어요").then{
        $0.isActivate = false
    }
    
    init(type: SelectEmotionType) {
        switch type {
        case .First:
            titleView = RegisterCommonTitleView(title: "소비한 순간의 \n솔직한 감정을 남겨주세요",
                                                subtitle: "포미는 순간의 감정에 집중해\n한번 기록된 감정은 바꿀 수 없어요")
        case .Second:
            titleView = RegisterCommonTitleView(title: "일주일이 지난 오늘의\n솔직한 감정을 남겨주세요",
                                                subtitle: "포미는 순간의 감정에 집중해\n한번 기록된 감정은 바꿀 수 없어요")
        }
        
        happyEmotionView = EmotionElementView.generateWithInfo(type: type, emotion: .happy)
        whatEmotionView = EmotionElementView.generateWithInfo(type: type, emotion: .what)
        sadEmotionView = EmotionElementView.generateWithInfo(type: type, emotion: .sad)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        
        super.hierarchy()
        
        addSubview(titleView)
        addSubview(emotionStackView)
        addSubview(completeButton)
        
        emotionStackView.addArrangedSubview(happyEmotionView)
        emotionStackView.addArrangedSubview(whatEmotionView)
        emotionStackView.addArrangedSubview(sadEmotionView)
    }
    
    override func layout() {
        
        titleView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        emotionStackView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(41)
            $0.leading.equalToSuperview().offset(89)
        }
        
        completeButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(35)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }

}

extension SelectEmotionView{
    
    class EmotionElementView: BaseView{
    
        private let emotion: EmotionTag
        private let type: SelectEmotionType
        
        private let imageBackView = UIView().then{
            let imageSize: CGFloat = Device.isSmallDevice ? 90 : 110
            $0.layer.cornerRadius = imageSize / 2
        }
        private let emotionImageView = UIImageView()
        private let titleLabel = UILabel().then{
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        }
        
        private init(type: SelectEmotionType, emotion: EmotionTag) {
            self.type = type
            self.emotion = emotion
            
            super.init(frame: .zero)
            initialize()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static func generateWithInfo(type: SelectEmotionType, emotion: EmotionTag) -> EmotionElementView{
            return EmotionElementView(type: type, emotion: emotion)
        }
        
        override func style() {
            isUserInteractionEnabled = true
        }
        
        override func hierarchy() {
            addSubview(imageBackView)
            addSubview(titleLabel)
            imageBackView.addSubview(emotionImageView)
        }
        
        override func layout() {
            imageBackView.snp.makeConstraints{
                let size = Device.isSmallDevice ? 90 : 110
                $0.width.height.equalTo(size)
                $0.top.bottom.leading.equalToSuperview()
            }
            
            emotionImageView.snp.makeConstraints{
                $0.top.leading.equalToSuperview().offset(21)
                $0.centerY.centerX.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints{
                $0.leading.equalTo(imageBackView.snp.trailing).offset(15)
                $0.trailing.centerY.equalToSuperview()
            }
        }
        
        private func initialize() {
            tag = emotion.tagBinding
            var emotionImage = UIImage()
            switch type {
                case .First: emotionImage = emotion.firstEmotionImage
                case .Second: emotionImage = emotion.secondEmotionImage
            }
            emotionImageView.image = emotionImage
            titleLabel.text = emotion.message
            changeDeselectState()
        }
        
        func changeDeselectState(){
            imageBackView.backgroundColor = Color.grey0
            titleLabel.textColor = Color.body
        }
        
        func changeSelectState(){
            var textColor = UIColor()
            var backgroundColor = UIColor()
            
            switch type {
                case .First:
                    backgroundColor = Color.mint10
                    textColor = Color.mint100
                case .Second:
                    backgroundColor = Color.pink10
                    textColor = Color.pink100
            }
            imageBackView.backgroundColor = backgroundColor
            titleLabel.textColor = textColor
        }
    }
}

