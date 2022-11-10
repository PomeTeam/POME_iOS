//
//  BaseLabel.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class BaseLabel: UILabel {
    var location: NSTextAlignment = .left

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    init(_ location: NSTextAlignment) {
        super.init(frame: CGRect.zero)
        
        self.location = location
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        
        if let text = text {
            let attrString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            self.attributedText = attrString
        }
        
        self.textAlignment = self.location
    }
}
