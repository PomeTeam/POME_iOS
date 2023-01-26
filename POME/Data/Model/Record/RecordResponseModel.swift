//
//  RecordResponseModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct RecordResponseModel: Decodable{
    let id: Int
    let usePrice: Int
    let useDate: String
    let useComment: String
    let oneLineMind: String
    var emotionResponse: EmotionResponseModel
}

struct EmotionResponseModel: Decodable{
    var firstEmotion: Int
    let secondEmotion: Int
    let friendEmotions: [Int]
}
