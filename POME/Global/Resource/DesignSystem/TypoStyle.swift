//
//  TypoStyle.swift
//  POME
//
//  Created by 박지윤 on 2022/11/16.
//

import Foundation
import UIKit

enum FontType{
    case Bold
    case SemiBold
    case Medium
    case Regular
}

struct FontDescription {
    let font: FontType
    let size: CGFloat
}

struct LabelDescription {
    let kern: Double
    let lineHeight: CGFloat
}

enum TypoStyle: Int, CaseIterable {
    case header1 = 0        // 24pt / bold / -0.72 / 38.4
    case header2           // 20pt / bold / -0.8 / 30
    
    case title1             // 20pt / semibold / -0.8 / 30
    case title2             // 18pt / semibold / -0.54 / 27
    case title3             // 16pt / semibold / -0.48 / 22.4
    case title4             // 14pt / semibold / -0.42 / 19.6
    case title5             // 12pt / semibold / -0.36 / 14.4
    case title6             // 10pt / semibold / -0.3 / 12
    
    case subtitle1          // 16pt / medium / -0.48 / 19.2
    case subtitle2          // 14pt / medium / -0.42 / 19.6
    case subtitle3          // 12pt / medium / -0.36 / 14.4
    
    case body1              // 16pt / regular / -0.48 / 25.6
    case body2              // 14pt / regular / -0.42 / 22.4
    case body3             // 12pt / regular / -0.36 / 18
}

extension TypoStyle {
    private var fontDescription: FontDescription {
        switch self {
        case .header1:      return FontDescription(font: .Bold, size: 24)
        case .header2:      return FontDescription(font: .Bold, size: 20)
        
        case .title1:       return FontDescription(font: .SemiBold, size: 20)
        case .title2:       return FontDescription(font: .SemiBold, size: 18)
        case .title3:       return FontDescription(font: .SemiBold, size: 16)
        case .title4:       return FontDescription(font: .SemiBold, size: 14)
        case .title5:       return FontDescription(font: .SemiBold, size: 12)
        case .title6:       return FontDescription(font: .SemiBold, size: 10)
        
        case .subtitle1:    return FontDescription(font: .Medium, size: 16)
        case .subtitle2:    return FontDescription(font: .Medium, size: 14)
        case .subtitle3:    return FontDescription(font: .Medium, size: 12)
        
        case .body1:        return FontDescription(font: .Regular, size: 16)
        case .body2:        return FontDescription(font: .Regular, size: 14)
        case .body3:        return FontDescription(font: .Regular, size: 12)
        }
    }
    
    public var labelDescription: LabelDescription {
        switch self {
        case .header1:      return LabelDescription(kern: -0.72, lineHeight: 38.4)
        case .header2:      return LabelDescription(kern: -0.8, lineHeight: 30)
        
        case .title1:       return LabelDescription(kern: -0.8, lineHeight: 30)
        case .title2:       return LabelDescription(kern: -0.54, lineHeight: 27)
        case .title3:       return LabelDescription(kern: -0.48, lineHeight: 22.4)
        case .title4:       return LabelDescription(kern: -0.42, lineHeight: 19.6)
        case .title5:       return LabelDescription(kern: -0.36, lineHeight: 14.4)
        case .title6:       return LabelDescription(kern: -0.3, lineHeight: 12)
        
        case .subtitle1:    return LabelDescription(kern: -0.48, lineHeight: 19.2)
        case .subtitle2:    return LabelDescription(kern: -0.42, lineHeight: 19.6)
        case .subtitle3:    return LabelDescription(kern: -0.36, lineHeight: 14.4)
        
        case .body1:        return LabelDescription(kern: -0.48, lineHeight: 25.6)
        case .body2:        return LabelDescription(kern: -0.42, lineHeight: 22.4)
        case .body3:        return LabelDescription(kern: -0.36, lineHeight: 18)
        }
    }
}

extension TypoStyle {
    var font: UIFont {
        guard let font = UIFont(name: "Pretendard-\(fontDescription.font)", size: fontDescription.size) else {
            return UIFont()
        }
        return font
    }
}

extension UILabel {
    
    func setTypoStyle(font: UIFont, kernValue: Double, lineSpacing: CGFloat) {
        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
            
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                                .kern:kernValue,
                                                .paragraphStyle: paragraphStyle,
                                                .baselineOffset: (lineSpacing - font.lineHeight) / 4
            ], range: NSRange(location: 0,
                              length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
    func setTypoStyleWithSingleLine(typoStyle: TypoStyle) {
        
        if(self.text == nil){
            self.text = " "
        }
        
        let font = typoStyle.font
        let kernValue = typoStyle.labelDescription.kern

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                            .kern:kernValue],
                                           range: NSRange(location: 0,
                                                          length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
    func setTypoStyleWithMultiLine(typoStyle: TypoStyle) {
        
        if(self.text == nil){
            self.text = " "
        }
        
        let font = typoStyle.font
        let kernValue = typoStyle.labelDescription.kern
        let lineSpacing = typoStyle.labelDescription.lineHeight

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                            .kern:kernValue,
                                            .paragraphStyle: paragraphStyle,
                                            .baselineOffset: (lineSpacing - font.lineHeight) / 4
            ], range: NSRange(location: 0,
                              length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
}

extension UITextView{
    
    func setTypoStyleWithMultiLine(typoStyle: TypoStyle) {

        if(self.text.isEmpty){
            self.text = " "
        }
        
        let font = typoStyle.font
        let kernValue = typoStyle.labelDescription.kern
        let lineSpacing = typoStyle.labelDescription.lineHeight
        
        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                            .kern:kernValue,
                                            .paragraphStyle: paragraphStyle,
                                            .baselineOffset: (lineSpacing - font.lineHeight) / 4
            ], range: NSRange(location: 0,
                              length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
}
