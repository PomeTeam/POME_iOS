//
//  DefaultButton.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class DefaultButton: UIButton {
    
    var isActivate = false{
        didSet{
            isActivate ? activateButton() : inactivateButton()
        }
    }
    var titleStr: String?
    var titleColor: UIColor?
    var typo: TypoStyle?
    
    // MARK: - Life Cycle
    
    // 디폴트 초록 배경 버튼
    init(titleStr: String) {
        super.init(frame: CGRect.zero)
        
        self.titleStr = titleStr
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .title3)
        self.backgroundColor = Color.mint100
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    // 배경색, 글씨색, 글씨체 설정
    init(titleStr: String, typo: TypoStyle, backgroundColor: UIColor, titleColor: UIColor) {
        super.init(frame: CGRect.zero)
        
        self.titleStr = titleStr
        self.titleColor = titleColor
        self.typo = typo
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.setTypoStyleWithSingleLine(typoStyle: typo)
        self.backgroundColor = backgroundColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    // 배경색, 글씨색, 글씨체, 상태 설정
    init(titleStr: String, typo: TypoStyle, backgroundColor: UIColor, titleColor: UIColor, subTitleStr: String) {
        super.init(frame: CGRect.zero)
        
        self.titleStr = titleStr
        self.titleColor = titleColor
        self.typo = typo
        
        self.setTitle(titleStr, for: .normal)
        self.setTitle(subTitleStr, for: .selected)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.setTypoStyleWithSingleLine(typoStyle: typo)
        self.backgroundColor = backgroundColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func isActivate(_ isActivate: Bool) {
        if isActivate {activateButton()}
        else {inactivateButton()}
    }
    
    func activateButton() {
        self.backgroundColor = Color.mint100
        self.isEnabled = true
    }
    func inactivateButton() {
        self.backgroundColor = Color.mint60
        self.isEnabled = false
    }
    func setUnderLine() {
        let text =  self.titleStr
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text?.count ?? 0))
        attributeString.addAttribute(.foregroundColor, value: self.titleStr, range: NSRange(location: 0, length: text?.count ?? 0))
        
        self.titleLabel?.attributedText = attributeString
        self.titleLabel?.setTypoStyleWithSingleLine(typoStyle: self.typo ?? .subtitle2)
    }
}
