//
//  DefaultTextViewInfo.swift
//  POME
//
//  Created by 박지윤 on 2022/12/29.
//

import Foundation

struct DefaultTextInfo{
    let placeholder: String
    let textCountLimit: Int?
}

//TODO: TextField 케이스 정리

enum TextFieldType{
    
}

enum TextViewType: String{
    case consume
    case comment
}

extension TextFieldType{
    
}

extension TextViewType{
    
    private var caseInfo: DefaultTextInfo{
        switch self{
        case .consume:      return DefaultTextInfo(placeholder: "소비에 대한 감상을 적어주세요 (150자)",
                                                   textCountLimit: 150)
        case .comment:      return DefaultTextInfo(placeholder: "목표에 대한 한줄 코멘트를 남겨보세요",
                                                   textCountLimit: 150)
        }
    }
    
    var placeholder: String{
        self.caseInfo.placeholder
    }
    
    var textCountLimit: Int?{
        self.caseInfo.textCountLimit
    }
}
