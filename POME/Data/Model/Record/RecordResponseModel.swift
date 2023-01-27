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
    let secondEmotion: Int?
    var myEmotion: Int?
    let friendEmotions: [Int]
}


extension RecordResponseModel{
    
    //TODO: 감정/리액션 없을 때 null
    
    var firstEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.firstEmotion) ?? .default
    }
    
    var secondEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.secondEmotion ?? Const.default) ?? .default
    }
    
    var myReactionBinding: UIImage{
        guard let reaction = self.emotionResponse.myEmotion else {
            return Image.emojiAdd
        }
        return Reaction(rawValue: reaction)?.defaultImage ?? Image.emojiAdd
    }
    
    var othersThumbnailReaction: Reaction{
        Reaction(rawValue: self.emotionResponse.friendEmotions.first!) ?? .happy
    }
    
    var othersReactionCount: Int{
        self.emotionResponse.friendEmotions.count
    }
}
