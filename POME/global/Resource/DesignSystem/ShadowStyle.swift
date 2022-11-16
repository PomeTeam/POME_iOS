//
//  ShadowDesignSystem.swift
//  POME
//
//  Created by 박지윤 on 2022/11/08.
//

import Foundation
import UIKit

struct ShadowDescription{
    let cornerRadius: CGFloat?
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
        case .goalCard:         return ShadowDescription(cornerRadius: 6,
                                                         shadowColor: UIColor(red: 0.427, green: 0.553, blue: 0.678, alpha: 0.1),
                                                         shadowRadius: 15, shadowOffset: CGSize(width: 0, height: 4))
            
        case .emojiCard:        return ShadowDescription(cornerRadius: 6,
                                                         shadowColor: UIColor(red: 0.427, green: 0.553, blue: 0.678, alpha: 0.12),
                                                         shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 2))
        
        case .friendCard:       return ShadowDescription(cornerRadius: 8,
                                                         shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                                         shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 0))
            
        case .floatingPencil:   return ShadowDescription(cornerRadius: 0,
                                                         shadowColor: UIColor(red: 0.431, green: 0.767, blue: 0.495, alpha: 0.15),
                                                         shadowRadius: 16, shadowOffset: CGSize(width: 0, height: 4))
            
        case .emojiFloating:    return ShadowDescription(cornerRadius: 54/2,
                                                         shadowColor: UIColor(red: 0.427, green: 0.553, blue: 0.678, alpha: 0.2),
                                                         shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 0))
            
        case .goalEdit:         return ShadowDescription(cornerRadius: 0,
                                                         shadowColor: UIColor(red: 0.427, green: 0.553, blue: 0.678, alpha: 0.15),
                                                         shadowRadius: 30, shadowOffset: CGSize(width: 0, height: 4))
            
        case .bottomBar:        return ShadowDescription(cornerRadius: 0,
                                                         shadowColor: UIColor(red: 0.969, green: 0.969, blue: 0.98, alpha: 0.6),
                                                         shadowRadius: 14, shadowOffset: CGSize(width: 0, height: -10))
            
        case .toggleOn:         return ShadowDescription(cornerRadius: 0,
                                                         shadowColor: UIColor(red: 1, green: 0.431, blue: 0.4, alpha: 0.8),
                                                         shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            
        case .toggleOff:        return ShadowDescription(cornerRadius: 0, shadowColor: Color.grey5,
                                                         shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
        }
    }
}

extension ShadowStyle{
    
    var cornerRadius: CGFloat?{
        return shadowDescription.cornerRadius
    }
    
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
        self.layer.cornerRadius = type.cornerRadius ?? 0
        self.layer.shadowColor = type.shadowColor
        self.layer.shadowOpacity = type.shadowOpacity
        self.layer.shadowRadius = type.shadowRadius
        self.layer.shadowOffset = type.shadowOffset
    }
    
    func setShadowStyle(cornerRadius: CGFloat ,shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize ){
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
}
