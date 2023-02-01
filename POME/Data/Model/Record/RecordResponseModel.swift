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
    
    var goalPromiseBinding: String{
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
        "\(self.usePrice)원"
    }
    
    var firstEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.firstEmotion ?? 0) ?? .default
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

extension RecordResponseModel{
    
    // "createdAt": "2023-01-27 20:11:04.000000"
    // "useDate": "2023.02.23"
    private var isTodayWritten: Bool{
        let createTimeReplace = createdAt.replacingOccurrences(of: "-", with: ".")
        let createTime = createTimeReplace.split(separator: "T")[0]
        return createTime == self.useDate
    }
    
    private func manufactureTimeData() -> String{
        let rawCreateTime = String(createdAt.split(separator: ".")[0])
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
