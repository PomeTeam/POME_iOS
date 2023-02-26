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
    let createdAt: String
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
    
    var friendGoalMindBinding: String{
        "· \(self.oneLineMind)"
    }
    
    var timeBinding: String{
        
        if(isTodayWritten){
            return "· \(manufactureTimeData())  "
        }
        
        let dateString = PomeDateFormatter.getRecordDateString(self.useDate)
        return "· \(dateString)  "
    }
    
    var priceBinding: String{
        // 가격 콤마 표시
        var result = GoalResponseModel.numberFormatter.string(from: NSNumber(value: self.usePrice)) ?? ""
        return "\(result)원"
    }
    
    var firstEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.firstEmotion) ?? .default
    }
    
    var secondEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.secondEmotion ?? Const.default) ?? .default
    }
    
    var friendReactions: [FriendReactionResponseModel]{
        self.emotionResponse.friendEmotions
    }
    
    //친구탭
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
    
    //회고탭
    var firstFriendReaction: Reaction{
        Reaction(rawValue: self.emotionResponse.friendEmotions.first!.emotionId) ?? .happy
    }
    
    var secondFriendReaction: Reaction{
        Reaction(rawValue: self.emotionResponse.friendEmotions[1].emotionId) ?? .happy
    }
    
    var othersReactionCountBindingInReview: Int{
        self.emotionResponse.friendEmotions.count - 1
    }
}

extension RecordResponseModel{
    
    // "createdAt": "2023-02-14T14:47:31.470725"
    // "useDate": "2023.02.23"
    private var isTodayWritten: Bool{
        return PomeDateFormatter.getTodayDate() == self.useDate
    }
    
    private func manufactureTimeData() -> String{
        let rawCreateTime = String(createdAt.replacingOccurrences(of: "T", with: " ").split(separator: ".")[0])
        let createTimeFormatter = DateFormatter().then{
            $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        guard let createTime: Date = createTimeFormatter.date(from: rawCreateTime) else {
            return ""
        }
        
        let current = Date()
        let intervalTime = (current.timeIntervalSince(createTime) / (60)).rounded()
        let time = Int(intervalTime)
        
        let hour = time / 60
        let minute =  time % 60
        
        return hour == 0 ? "\(minute)분 전" : "\(hour)시간 전"
    }
    
}
