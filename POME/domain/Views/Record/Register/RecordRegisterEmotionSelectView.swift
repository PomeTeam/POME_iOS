//
//  RecordRegisterEmotionSelectView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit
import SnapKit

class RecordRegisterEmotionSelectView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "소비한 순간의 \n솔직한 감정을 남겨주세요",
                                         subtitle: "포미는 순간의 감정에 집중해 \n한번 기록된 감정은 바꿀 수 없어요")
    
    let emotionStackView = UIStackView().then{
        $0.spacing = 40
        $0.axis = .vertical
    }
    
    let happyEmotionView = FirstEmotionView.generateWithInfo(emotion: .happy)
    
    let whatEmotionView = FirstEmotionView.generateWithInfo(emotion: .what)
    
    let sadEmotionView = FirstEmotionView.generateWithInfo(emotion: .sad)
    
    lazy var completeButton = DefaultButton(titleStr: "남겼어요")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.addSubview(titleView)
        self.addSubview(emotionStackView)
        self.addSubview(completeButton)
        
        emotionStackView.addArrangedSubview(happyEmotionView)
        emotionStackView.addArrangedSubview(whatEmotionView)
        emotionStackView.addArrangedSubview(sadEmotionView)
    }
    
    override func layout() {
        
        titleView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        emotionStackView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(41)
            $0.leading.equalToSuperview().offset(89)
        }
        
        completeButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }

}

extension RecordRegisterEmotionSelectView{
    
    class FirstEmotionView: BaseView{
        
        let imageBackView = UIView().then{
            $0.layer.cornerRadius = 110 / 2
//            $0.backgroundColor = Color.grey0
        }
        
        let emotionImageView = UIImageView()
        
        let titleLabel = UILabel().then{
            $0.text = " "
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
//            $0.textColor = Color.body
        }
        
        private init(emotion: EmotionTag) {
            
            super.init(frame: .zero)
            
            self.isUserInteractionEnabled = true
            emotionImageView.image = emotion.firstEmotionImage
            titleLabel.text = emotion.message
            changeDeselectSelect()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static func generateWithInfo(emotion: EmotionTag) -> FirstEmotionView{
            return FirstEmotionView(emotion: emotion)
        }
        
        override func hierarchy() {
            
            self.addSubview(imageBackView)
            self.addSubview(titleLabel)
            
            imageBackView.addSubview(emotionImageView)
        }
        
        override func layout() {
            imageBackView.snp.makeConstraints{
                $0.width.height.equalTo(110)
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
        
        func changeDeselectSelect(){
            self.tag = 0
            imageBackView.backgroundColor = Color.grey0
            titleLabel.textColor = Color.body
        }
        
        func changeSelectState(){
            self.tag = 1
            imageBackView.backgroundColor = Color.mint10
            titleLabel.textColor = Color.mint100
        }
    }
}
