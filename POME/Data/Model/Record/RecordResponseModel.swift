//
//  RecordResponseModel.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

struct RecordResponseModel: Decodable{
    let id: Int
    let nickname: String
    let usePrice: Int
    let useDate: String
    let useComment: String
    let oneLineMind: String
    var emotionResponse: EmotionResponseModel
}

struct EmotionResponseModel: Decodable{
    let firstEmotion: Int
    let secondEmotion: Int
    var myEmotion: Int
    let friendEmotions: [Int]
}


extension RecordResponseModel{
    
    var firstEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.firstEmotion) ?? .happy
    }
    
    var secondEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.secondEmotion) ?? .happy
    }
    
    var myReactionBinding: Reaction{
        Reaction(rawValue: self.emotionResponse.myEmotion) ?? .happy
    }
}
