//
//  UserManager.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

class UserManager {
    @UserDefault(key: UserDefaultKey.id, defaultValue: nil)
    static var userId: String?
    
    @UserDefault(key: UserDefaultKey.token, defaultValue: nil)
    static var token: String?
    
    @UserDefault(key: UserDefaultKey.phoneNum, defaultValue: nil)
    static var phoneNum: String?
}
