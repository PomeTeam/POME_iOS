//
//  ShadowDesignSystem.swift
//  POME
//
//  Created by 박지윤 on 2022/11/08.
//

import Foundation
import UIKit

struct ShadowDescription{
    let shadowColor: UIColor
    let shadowOpacity: Float = 1
    let shadowRadius: CGFloat
    let shadowOffset: CGSize
}

enum ShadowStyle{
    case goalCard
    case emojiCard
    case friendCard
    
    case floatingPencil
    case emojiFloating
    case goalEdit
    case bottomBar
    
    case toggleOn
    case toggleOff
}

extension ShadowStyle{
    
    private var shadowDescription: ShadowDescription{
        switch self{
        case .goalCard:         return ShadowDescription(shadowColor: Color.shadow,
                                                         shadowRadius: 15, shadowOffset: CGSize(width: 0, height: 4))
            
        case .emojiCard:        return ShadowDescription(shadowColor: Color.shadow,
                                                         shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 2))
        
        case .friendCard:       return ShadowDescription(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                                         shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 0))
            
        case .floatingPencil:   return ShadowDescription(shadowColor: UIColor(red: 0.431, green: 0.767, blue: 0.495, alpha: 0.15),
                                                         shadowRadius: 16, shadowOffset: CGSize(width: 0, height: 4))
            
        case .emojiFloating:    return ShadowDescription(shadowColor: Color.shadow,
                                                         shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 0))
            
        case .goalEdit:         return ShadowDescription(shadowColor: Color.shadow,
                                                         shadowRadius: 30, shadowOffset: CGSize(width: 0, height: 4))
            
        case .bottomBar:        return ShadowDescription(shadowColor: UIColor(red: 0.969, green: 0.969, blue: 0.98, alpha: 0.6),
                                                         shadowRadius: 14, shadowOffset: CGSize(width: 0, height: -10))
            
        case .toggleOn:         return ShadowDescription(shadowColor: UIColor(red: 1, green: 0.431, blue: 0.4, alpha: 0.8),
                                                         shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            
        case .toggleOff:        return ShadowDescription(shadowColor: Color.grey_5,
                                                         shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
        }
    }
}

extension ShadowStyle{
    
    var shadowColor: CGColor{
        return shadowDescription.shadowColor.cgColor
    }
    
    var shadowOpacity: Float{
        return shadowDescription.shadowOpacity
    }
    
    var shadowRadius: CGFloat{
        return shadowDescription.shadowRadius
    }
    
    var shadowOffset: CGSize{
        return shadowDescription.shadowOffset
    }
}

extension UIView{
    
    func setShadowStyle(type: ShadowStyle){
        self.layer.shadowColor = type.shadowColor
        self.layer.shadowOpacity = type.shadowOpacity
        self.layer.shadowRadius = type.shadowRadius
        self.layer.shadowOffset = type.shadowOffset
    }
    
    func setShadowStyle(shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize ){
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
}
