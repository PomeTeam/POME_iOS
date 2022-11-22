//
//  EmotionFilterSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class EmotionFilterSheetView: BaseView {
    
    let topView = UIView()
    
    let titleLabel = UILabel().then{
        $0.text = " "
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.body
    }
    
    let cancelButton = UIButton().then{
        $0.setImage(Image.sheetCancel, for: .normal)
    }
    
    let filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumInteritemSpacing = 10
            $0.minimumLineSpacing = 10
            $0.itemSize = CGSize(width: EmotionFilterSheetCollectionViewCell.cellWidth, height: EmotionFilterSheetCollectionViewCell.cellWidth)
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        
        $0.register(EmotionFilterSheetCollectionViewCell.self, forCellWithReuseIdentifier: EmotionFilterSheetCollectionViewCell.cellIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        
        self.addSubview(topView)
        self.addSubview(filterCollectionView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(cancelButton)
    }
    
    override func layout() {
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        cancelButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(cancelButton.snp.height)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        filterCollectionView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    

}
