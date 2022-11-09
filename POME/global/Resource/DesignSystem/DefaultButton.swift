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
    init(titleStr: String) {
        super.init(frame: CGRect.zero)
        
        self.setTitle(titleStr, for: .normal)
        self.titleLabel?.font = UIFont.autoPretendard(type: .b_18)
        self.titleLabel?.textColor = .white
        self.backgroundColor = Color.main
        
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
        self.backgroundColor = Color.main
        self.isEnabled = true
    }
    func inactivateButton() {
        self.backgroundColor = Color.disabled_mint
        self.isEnabled = false
    }
}
