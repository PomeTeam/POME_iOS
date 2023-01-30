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
    let friendEmotions: [FriendReactionResponseModel]
}

struct FriendReactionResponseModel: Decodable{
    let emotionId: Int
    let nickname: String
}

extension RecordResponseModel{
    
    var goalPromiseBinding: String{
        "· \(self.oneLineMind)"
    }
    
    //TODO: 시간 데이터 가공
    /*
     당일인 경우
     분 단위(44분 전) > 시간 단위(1시간 전)
     
     당일이 아닌 경우
     소비 날짜(6월 24일) 포맷
     */
    var timeBinding: String{
        "· \(self.useDate)  "
    }
    
    var priceBinding: String{
        "\(self.usePrice)원"
    }
    
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
    
    var othersThumbnailReactionBinding: Reaction{
        Reaction(rawValue: self.emotionResponse.friendEmotions.first!.emotionId) ?? .happy
    }
    
    var othersReactionCountBinding: Int{
        self.emotionResponse.friendEmotions.count
    }
    
    var friendReactions: [FriendReactionResponseModel]{
        self.emotionResponse.friendEmotions
    }
}
