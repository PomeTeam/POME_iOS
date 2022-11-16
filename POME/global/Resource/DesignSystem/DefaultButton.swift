//
//  DefaultButton.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import Foundation
import UIKit

class DefaultButton: UIButton {
    
    // MARK: - Life Cycle
    
    // 디폴트 초록 배경 버튼
    init(titleStr: String) {
        super.init(frame: CGRect.zero)
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.autoPretendard(type: .b_18)
        self.backgroundColor = Color.mint100
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    // 배경색, 글씨색 설정
    init(titleStr: String, backgroundColor: UIColor, titleColor: UIColor) {
        super.init(frame: CGRect.zero)
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.autoPretendard(type: .b_18)
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
}
