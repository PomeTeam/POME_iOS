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
    case tabBar
    case card
}

extension ShadowStyle{
    
    private var shadowDescription: ShadowDescription{
        switch self{
        case .card:             return ShadowDescription(cornerRadius: 6,
                                                         shadowColor: UIColor(red: 127/255, green: 137/255, blue: 157/255, alpha: 0.12),
                                                         shadowRadius: 30,
                                                         shadowOffset: CGSize(width: 0, height: 10))
            
        case .tabBar:           return ShadowDescription(cornerRadius: 0,
                                                         shadowColor: UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 0.6),
                                                         shadowRadius: 14,
                                                         shadowOffset: CGSize(width: 0, height: -10))
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
