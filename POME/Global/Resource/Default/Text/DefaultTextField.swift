//
//  DefaultTextField.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import Foundation
import UIKit

class DefaultTextField: UITextField {
    
    var countLimit: Int?
    var isFocusState: Bool = false{ //true false 설정해주면 됩니다
        didSet{
            backgroundColor = isFocusState ? Color.grey1 : Color.grey0
        }
    }
    
    init() {
        
        super.init(frame: CGRect.zero)

        self.clearButtonMode = .always
        self.addLeftPadding(16)
        
        initialize()
    }
    
    // 디폴트 textfield
    init(placeholderStr: String) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholderStr
        self.clearButtonMode = .always
        self.addLeftPadding(16)
        
        initialize()
    }
    // padding 있는 textfield
    init(_ placeholderStr: String, _ leftPadding: CGFloat, _ rightPadding: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholderStr
//        self.clearButtonMode = .always

        self.addLeftPadding(leftPadding)
        self.addRightPadding(rightPadding)
        
        initialize()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(){
        
        self.font = UIFont.autoPretendard(type: .r_14)
        self.textColor = Color.title
        self.backgroundColor = Color.grey0
        
        self.layer.cornerRadius = 6
    }
}
