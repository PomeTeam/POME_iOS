//
//  KeyboardController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation

class KeyboardController{
    
    private let view: UIView
    private let moveHeight: CGFloat
    
    init(view: UIView, moveHeight: CGFloat){
        self.view = view
        self.moveHeight = moveHeight
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let moveHeight = keyboardRectangle.height - moveHeight
            UIView.animate(
                withDuration: 0.3
                , animations: { [weak self] in
                    self?.view.transform = CGAffineTransform(translationX: 0, y: -moveHeight)
                }
            )
        }
    }

    @objc private func keyboardWillDisappear(noti: NSNotification) {
        view.transform = .identity
    }
}
