//
//  EmotionFilterSheetCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class EmotionFilterSheetCollectionViewCell: BaseCollectionViewCell {
    
    static let cellIdentifier = "EmotionFilterSheetCollectionViewCell"
    
    /*
     left, right padding = 26
     spacing = 10
     */
    static let cellWidth: CGFloat = (Const.Device.WIDTH - (26 * 2 + 10 * 2))/3
    
    let emotionImage = UIImageView().then{
        $0.image = Image.emojiSad
    }
    
    let emotionLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        super.hierarchy()
        
        baseView.addSubview(emotionImage)
        baseView.addSubview(emotionLabel)
    }
    
    override func layout() {
        
        self.baseView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.bottom.trailing.equalToSuperview().offset(-10)
        }
        
        emotionImage.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(13.5)
            $0.height.equalTo(emotionImage.snp.width)
        }
        
        emotionLabel.snp.makeConstraints{
            $0.top.equalTo(emotionImage.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
}
