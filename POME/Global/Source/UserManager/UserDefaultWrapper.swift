//
//  UserDefaultWrapper.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

@propertyWrapper

struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
    
}
