//
//  ReviewEmptyView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewEmptyView: BaseView {

    let emptyImage = UIImageView().then{
        $0.image = Image.noting
    }

    let emptyLabel = UILabel().then{
        $0.text = "아직 돌아본 씀씀이가 없어요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
        $0.numberOfLines = 1
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy(){
        self.addSubview(emptyImage)
        self.addSubview(emptyLabel)
    }
    
    override func layout(){
        
        emptyImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(130)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        emptyLabel.snp.makeConstraints{
            $0.top.equalTo(emptyImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
}
