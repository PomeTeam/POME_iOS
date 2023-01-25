//
//  BaseResponseModel.swift
//  POME
//
//  Created by gomin on 2023/01/26.
//

import Foundation

struct BaseResponseModel<T: Decodable>: Decodable{
    let success: Bool?
    let httpCode: Int?
    let localDateTime: String?
    let httpStatus: String?
    let message: String?
    let data: T?
}
