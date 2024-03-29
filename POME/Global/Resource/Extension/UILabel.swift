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
    func countCurrentLines() -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font              else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        // kern을 설정하면 자간 간격이 조정되기 때문에, 크기에 영향을 미칠 수 있습니다.
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        // width을 제한한 상태에서 해당 Text의 Height를 구하기 위해 boundingRect 사용
        let labelTextSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        // 총 Height에서 한 줄의 Line Height를 나누면 현재 총 Line 수
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
    // Bullet List - 탈퇴 시
    func setBulletPointList(strings: [String]) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.lineHeightMultiple = 1.33
        paragraphStyle.lineSpacing = 12
        paragraphStyle.maximumLineHeight = 25.6
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(size: 16, family: .Regular),
            NSAttributedString.Key.foregroundColor: Color.body,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ]
        
        let string = strings.map { "•\t\($0)" }.joined(separator: "\n")

        attributedText = NSAttributedString(string: string,
                                            attributes: stringAttributes)
    }
}
