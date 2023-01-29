//
//  StatusResponseModel.swift
//  POME
//
//  Created by gomin on 2023/01/29.
//

import Foundation

struct StatusResponseModel: Decodable{
    let success: Bool
    let httpCode: Int
    let localDateTime: String
    let httpStatus: String
    let message: String
}
