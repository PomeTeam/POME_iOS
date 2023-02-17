//
//  PaddingLabel.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class PaddingLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    // MARK: Level Set
    func setLevelLabel(_ type: MarshmallowType, _ level: Int) {
        self.then{
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.setTypoStyleWithSingleLine(typoStyle: .title5)
            $0.textAlignment = .center
        }
            
        switch type {
        case .emotion:
            self.text = "기록말랑"
        case .growth:
            self.text = "공감말랑"
        case .honest:
            self.text = "발전말랑"
        case .record:
            self.text = "솔직말랑"
        }
        
        switch level {
        case 1:
            self.textColor = Color.grey5
            self.backgroundColor = Color.grey1
        case 2:
            self.textColor = Color.pink100
            self.backgroundColor = Color.pink30
        case 3:
            self.textColor = Color.pink100
            self.backgroundColor = Color.pink30
        case 4:
            self.textColor = Color.pink100
            self.backgroundColor = Color.pink30
        default:
            self.textColor = Color.grey5
            self.backgroundColor = Color.grey1
        }
    }
    
    func setLevelIcon(_ level: Int) {
        self.then{
            $0.text = "Lv.\(level + 1)"
            $0.setTypoStyleWithSingleLine(typoStyle: .title6)
            $0.textAlignment = .center
            
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 12
        }
        
        switch level {
        case 1:
            self.textColor = Color.grey4
            self.layer.borderColor = Color.grey4.cgColor
        case 2:
            self.textColor = Color.pink100
            self.layer.borderColor = Color.pink100.cgColor
        case 3:
            self.textColor = Color.pink100
            self.layer.borderColor = Color.pink100.cgColor
        case 4:
            self.textColor = Color.pink100
            self.layer.borderColor = Color.pink100.cgColor
        default:
            self.textColor = Color.grey4
            self.layer.borderColor = Color.grey4.cgColor
        }
    }

}
