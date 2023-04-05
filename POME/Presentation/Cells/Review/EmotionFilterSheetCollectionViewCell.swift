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
    static let cellWidth: CGFloat = (Device.WIDTH - (26 * 2 + 10 * 2))/3
    var emotionImage: UIImage!{
        didSet{
            emotionImageView.image = emotionImage
        }
    }
    var emotionTitle: String!{
        didSet{
            emotionLabel.text = emotionTitle
        }
    }
    
    private let emotionImageView = UIImageView()
    private let emotionLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
    }
    
    override func hierarchy() {
        super.hierarchy()
        baseView.addSubview(emotionImageView)
        baseView.addSubview(emotionLabel)
    }
    
    override func layout() {
        baseView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        emotionImageView.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(13.5)
            $0.height.equalTo(emotionImageView.snp.width)
        }
        emotionLabel.snp.makeConstraints{
            $0.top.equalTo(emotionImageView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
