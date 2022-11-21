//
//  TagStyle.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import Foundation
import UIKit

enum TagStyle{
    case Day
    case Lock
}

extension TagStyle{
    
    var backgroundColor: UIColor{
        switch self{
        case .Day:      return Color.pink10
        case .Lock:     return Color.grey1
        }
    }
    
    var textColor: UIColor{
        switch self{
        case .Day:      return Color.pink100
        case .Lock:     return Color.grey5
        }
    }
}

class TagLabel: BaseView{
    
    var tagStyle: TagStyle!
    
    let tagLabel = UILabel().then{
        $0.text = " "
        $0.setTypoStyleWithSingleLine(typoStyle: .title6)
    }
    
    //MARK: - LifeCycle
    
    init(style: TagStyle){
        self.tagStyle = style
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    static func generateDayTag() -> TagLabel{
//        return TagLabel(style: .Day)
//    }
//
//    static func generateLockTag() -> TagLabel{
//        return TagLabel(style: .Lock)
//    }
    
    //MARK: - Override
    
    override func style() {
        
        self.layer.cornerRadius = 4
        
        self.backgroundColor = tagStyle.backgroundColor
        self.tagLabel.textColor = tagStyle.textColor
    }
    
    override func hierarchy() {
        self.addSubview(tagLabel)
    }
    
    override func layout() {
        
        self.snp.makeConstraints{
            $0.height.equalTo(20)
        }
        
        tagLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(6)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
}

/*
 Tag Label
 -> Lock / D-day
 */

class LockTagLabel: TagLabel{
    
    private enum LockType: String{
        case open = "공개"
        case unopen = "비공개"
    }
    
    private init(type: LockType){
        super.init(style: .Lock)
        self.tagLabel.text = type.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func generateUnopenTag() -> LockTagLabel{
        return LockTagLabel(type: .open)
    }
    
    static func generateOpenTag() -> LockTagLabel{
        return LockTagLabel(type: .unopen)
    }
}

class DayTagLabel: TagLabel{
    
    private enum DayType: String{
        case remain = "D-"
        case end = "END"
    }
    
    private init(type: DayType){
        super.init(style: .Day)
        self.tagLabel.text = type.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func generateDateRemainTag() -> DayTagLabel{
        return DayTagLabel(type: .remain)
    }
    
    static func generateDateEndTag() -> DayTagLabel{
        return DayTagLabel(type: .end)
    }
}
