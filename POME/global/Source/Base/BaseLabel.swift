//
//  BaseLabel.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class BaseLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    override func drawText(in rect: CGRect) {
        if let text = text {
            let attrString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            self.attributedText = attrString
        }
        
        super.drawText(in: rect)
    }
}