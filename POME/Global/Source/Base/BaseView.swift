//
//  BaseView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/05.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    /*
     BaseView method
     
     1. hierarchy: addSubview, addArrangedSubview 등의 코드를 처리하는 메서드입니다.
     2. constraint: SnapKit을 통한 View의 레이아웃을 조정하는 메서드입니다.
     */
    
    func style() {}
    
    func hierarchy() {}
    
    func layout() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
