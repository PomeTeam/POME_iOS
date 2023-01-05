//
//  UILabel.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

extension UILabel {
    func setUnderLine(_ title: String, _ font: UIFont, _ textColor: UIColor) {
        let text = title
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        attributeString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributeString
    }
}
