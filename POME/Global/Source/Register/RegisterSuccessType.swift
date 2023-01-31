//
//  RegisterSuccessType.swift
//  POME
//
//  Created by 박지윤 on 2022/12/15.
//

import Foundation

enum RegisterSuccessType{
    case goal
    case consume
}

struct RegisterSuccessViewInfo{
    let titleMessage: String
    let subtitleMessage: String
    let image: UIImage
}

extension RegisterSuccessType{
    
    private var typeInfo: RegisterSuccessViewInfo{
        switch self{
        case .goal:     return RegisterSuccessViewInfo(titleMessage: "새로운 목표를\n추가했어요!",
                                                       subtitleMessage: "목표를 달성할 수 있도록 포미가 응원할게요!",
                                                       image: Image.goalRegisterSuccess)
            
        case .consume:  return RegisterSuccessViewInfo(titleMessage: "새로운 씀씀이 기록이\n추가되었어요!",
                                                       subtitleMessage: "잊지 않고 기록해주셨네요! 정말 대단해요",
                                                       image: Image.recordRegisterSuccess)
        }
    }
    
    var title: String{
        self.typeInfo.titleMessage
    }
    
    var subtitle: String{
        self.typeInfo.subtitleMessage
    }
    
    var image: UIImage{
        self.typeInfo.image
    }
    
    
}
