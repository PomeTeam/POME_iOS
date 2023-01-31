//
//  ReviewEmptyView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewEmptyView: BaseView {
    
    let stackView = UIStackView().then{
        $0.spacing = 12
        $0.axis = .vertical
        $0.alignment = .center
    }

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
    
    override func hierarchy(){
        self.addSubview(stackView)
        stackView.addArrangedSubview(emptyImage)
        stackView.addArrangedSubview(emptyLabel)
    }
    
    override func layout(){
        
        stackView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emptyImage.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
    }
}
