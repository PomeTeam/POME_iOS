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
    var isFocusState: Bool = false{
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
    
    // MARK: Clear button Custom
    func setClearButton(mode: UITextField.ViewMode) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(Image.textFieldClearButton, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(DefaultTextField.clear(sender:)), for: .touchUpInside)
        
        self.addTarget(self, action: #selector(DefaultTextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(DefaultTextField.displayClearButtonIfNeeded), for: .editingChanged)
        
        self.rightView = clearButton
        self.rightViewMode = mode
    }
    @objc private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    @objc private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    // clear button position
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.offsetBy(dx: -13, dy: 0)
    }
}

extension UITextField{
    func setUnfocusState(){
        (self as? DefaultTextField)?.isFocusState = false
    }
    
    func setFocusState(){
        (self as? DefaultTextField)?.isFocusState = true
    }
}
