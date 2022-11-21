//
//  TagStyle.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import Foundation

enum TagStyle{
    case Day
    case Lock
}

class TagLabel: BaseView{
    
    let tagLabel = UILabel()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func generateDayTag(){
        
    }
    
    static func generateLockTag(){
        
    }
    
    //MARK: - Override
    
    override func style() {
        
    }
    
    override func hierarchy() {
        
    }
    
    override func layout() {
        
    }
    
}
