//
//  BaseCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    let baseView = UIView().then{
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {}
    
    func hierarchy(){
        self.contentView.addSubview(baseView)
    }
    
    func layout(){
        baseView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
