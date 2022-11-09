//
//  UITextField.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

extension UITextField {
    // 텍스트필드 왼쪽 padding 주기
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
