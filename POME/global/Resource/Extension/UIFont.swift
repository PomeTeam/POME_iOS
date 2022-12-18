//
//  UIFont+Extension.swift
//  POME
//
//  Created by 박지윤 on 2022/11/05.
//

import Foundation
import UIKit

extension UIFont{
    
//    == Pretendard-Regular
//    == Pretendard-Medium
//    == Pretendard-SemiBold
//    == Pretendard-Bold
    
    enum Family: String {
        case SemiBold, Bold, Medium, Regular
    }
    
    enum AutoText{
        case b_24
        case b_22
        case b_20
        case b_18
        case b_16
        case b_14
        case b_12
        
        case sb_20
        case sb_18
        case sb_16
        case sb_14
        case sb_12
        case sb_10
        
        case m_20
        case m_18
        case m_16
        case m_14
        case m_12
        
        case r_18
        case r_16
        case r_14
        case r_12
    }

    static func pretendard(size: CGFloat, family: Family) -> UIFont! {
        guard let font: UIFont = UIFont(name: "Pretendard-\(family)", size: size) else{
            return nil
        }
        return font
    }
    
    static func autoPretendard(type: AutoText) -> UIFont {
        switch type {
        case .b_24:
            return UIFont(name: "Pretendard-Bold", size: 24)!
        case .b_22:
            return UIFont(name: "Pretendard-Bold", size: 22)!
        case .b_20:
            return UIFont(name: "Pretendard-Bold", size: 20)!
        case .b_18:
            return UIFont(name: "Pretendard-Bold", size: 18)!
        case .b_16:
            return UIFont(name: "Pretendard-Bold", size: 16)!
        case .b_14:
            return UIFont(name: "Pretendard-Bold", size: 14)!
        case .b_12:
            return UIFont(name: "Pretendard-Bold", size: 12)!
            
        case .sb_20:
            return UIFont(name: "Pretendard-SemiBold", size: 20)!
        case .sb_18:
            return UIFont(name: "Pretendard-SemiBold", size: 18)!
        case .sb_16:
            return UIFont(name: "Pretendard-SemiBold", size: 16)!
        case .sb_14:
            return UIFont(name: "Pretendard-SemiBold", size: 14)!
        case .sb_12:
            return UIFont(name: "Pretendard-SemiBold", size: 12)!
        case .sb_10:
            return UIFont(name: "Pretendard-SemiBold", size: 10)!
            
            
        case .m_20:
            return UIFont(name: "Pretendard-Medium", size: 20)!
        case .m_18:
            return UIFont(name: "Pretendard-Medium", size: 18)!
        case .m_16:
            return UIFont(name: "Pretendard-Medium", size: 16)!
        case .m_14:
            return UIFont(name: "Pretendard-Medium", size: 14)!
        case .m_12:
            return UIFont(name: "Pretendard-Medium", size: 12)!
            
        case .r_18:
            return UIFont(name: "Pretendard-Regular", size: 18)!
        case .r_16:
            return UIFont(name: "Pretendard-Regular", size: 16)!
        case .r_14:
            return UIFont(name: "Pretendard-Regular", size: 14)!
        case .r_12:
            return UIFont(name: "Pretendard-Regular", size: 12)!
        }
    }
}
