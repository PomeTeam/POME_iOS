//
//  FriendReactionSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetView: BaseView {
    
    //MARK: - Properties
    
    let emotionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
    }
    
    let countView = UIView()
    
    let countLabel = UILabel().then{
        $0.text = "전체 6개"
        $0.setTypoStyle(typoStyle: .subtitle3)
        $0.textColor = Color.body
    }
    
    let friendEmotionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    override init(frame: CGRect) {
        super.init(frame: frame)
        emotionCollectionView.backgroundColor = .blue
        friendEmotionCollectionView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        self.addSubview(emotionCollectionView)
        self.addSubview(separatorLine)
        self.addSubview(countView)
        self.addSubview(friendEmotionCollectionView)
        
        countView.addSubview(countLabel)
    }
    
    override func layout() {
        
        emotionCollectionView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        separatorLine.snp.makeConstraints{
            $0.bottom.equalTo(emotionCollectionView)
            $0.leading.trailing.equalToSuperview()
        }
        
        countView.snp.makeConstraints{
            $0.height.equalTo(34)
            $0.top.equalTo(separatorLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        friendEmotionCollectionView.snp.makeConstraints{
            $0.top.equalTo(countView.snp.bottom)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
}
