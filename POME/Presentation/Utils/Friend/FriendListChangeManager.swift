//
//  FriendListChangeManager.swift
//  POME
//
//  Created by 박소윤 on 2023/02/21.
//

import Foundation

final class FriendListChangeManager{
    
    static let shared = FriendListChangeManager()
    
    private init() { }
    
    var isChange = false
    
    func initialize(){
        isChange = false
    }
}
