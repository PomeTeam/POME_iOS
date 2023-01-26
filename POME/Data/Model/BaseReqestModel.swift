//
//  BaseReqestModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct BaseRequestModel<T: Encodable>: Encodable{
    let request: T
    let userId: String = UserManager.userId ?? ""
}
