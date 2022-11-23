//
//  DefaultTextField.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import Foundation
import UIKit

class DefaultTextField: UITextField {
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.font = UIFont.autoPretendard(type: .r_14)
        self.textColor = Color.title
        
        self.backgroundColor = Color.grey0
        self.clearButtonMode = .always
        
        self.layer.cornerRadius = 6
        self.addLeftPadding(16)
    }
    
    // 디폴트 textfield
    init(placeholderStr: String) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholderStr
        self.font = UIFont.autoPretendard(type: .r_14)
        self.textColor = Color.title
        
        self.backgroundColor = Color.grey0
        self.clearButtonMode = .always
        
        self.layer.cornerRadius = 6
        self.addLeftPadding(16)
    }
    // padding 있는 textfield
    init(_ placeholderStr: String, _ leftPadding: CGFloat, _ rightPadding: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholderStr
        self.font = UIFont.autoPretendard(type: .r_14)
        self.textColor = Color.title
        
        self.backgroundColor = Color.grey0
//        self.clearButtonMode = .always
        
        self.layer.cornerRadius = 6
        self.addLeftPadding(leftPadding)
        self.addRightPadding(rightPadding)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
