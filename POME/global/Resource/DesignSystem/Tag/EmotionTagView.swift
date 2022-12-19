//
//  EmojiTagView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class EmotionTagView: BaseView {
    
    //MARK: - Properties
    
    let stackView = UIStackView().then{
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    let emotionImage = UIImageView()
    
    let emotionLabel = UILabel().then{
        $0.textColor = Color.body
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle3)
        $0.numberOfLines = 1
    }

    //MARK: - LifeCycle
    init(){
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    override func style() {
        self.backgroundColor = Color.grey1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    override func hierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(emotionImage)
        stackView.addArrangedSubview(emotionLabel)
    }
    
    override func layout() {
        
        stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-5)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        emotionImage.snp.makeConstraints{
            $0.width.height.equalTo(16)
        }
        
        emotionLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Method
    
    func setTagInfo(when: EmotionTime, state: EmotionTag){
        
        emotionImage.image = when == .first ? state.firstEmotionImage : state.secondEmotionImage
        
        emotionLabel.text = state.message
    }
}
