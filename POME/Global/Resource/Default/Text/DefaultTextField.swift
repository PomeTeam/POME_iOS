//
//  DefaultTextField.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import Foundation
import UIKit
import RxSwift

class DefaultTextField: UITextField {
    
    var countLimit: Int?
    var isFocusState: Bool = false{
        didSet{
            backgroundColor = isFocusState ? Color.grey1 : Color.grey0
        }
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero)

        clearButtonMode = .always
        addLeftPadding(16)
        
        initialize()
    }
    
    // 디폴트 textfield
    init(placeholderStr: String) {
        super.init(frame: CGRect.zero)
        
        placeholder = placeholderStr
        clearButtonMode = .always
        addLeftPadding(16)
        
        initialize()
    }
    // padding 있는 textfield
    init(placeholder: String, leftPadding: CGFloat, rightPadding: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholder
//        self.clearButtonMode = .always

        addLeftPadding(leftPadding)
        addRightPadding(rightPadding)
        
        initialize()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(){
        font = UIFont.autoPretendard(type: .r_14)
        textColor = Color.title
        backgroundColor = Color.grey0
        layer.cornerRadius = 6
        bind()
    }
    
    private func bind(){
        self.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext:{ [weak self] in
                UIView.animate(withDuration: 0.1){
                    self?.isFocusState = true
                }
            }).disposed(by: disposeBag)
        
        self.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext:{ [weak self] in
                UIView.animate(withDuration: 0.2){
                    self?.isFocusState = false
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: Clear button Custom
    func setClearButton(mode: UITextField.ViewMode) {
        self.clearButtonMode = .never
        
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
