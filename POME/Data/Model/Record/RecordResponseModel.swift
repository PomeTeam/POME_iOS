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
    let firstEmotion: Int?
    let secondEmotion: Int?
    var myEmotion: Int     // 처음 기록 생성 시 감정
    let friendEmotions: [FriendReactionResponseModel]
}

struct FriendReactionResponseModel: Decodable{
    let emotionId: Int
    let nickname: String
}

// 목표에 기록된 씀씀이 조회
struct RecordOfGoalResponseModel: Decodable {
    let content: [RecordContentResponseModel]
    let pageable: PagingModel
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: SortModel
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

struct RecordContentResponseModel: Decodable {
    let id: Int
    let nickname: String
    let usePrice: Int
    let useDate: String
    let useComment: String
    let oneLineMind: String
    let createdAt: String
    let emotionResponse: EmotionResponseModel
}

struct PagingModel: Decodable {
    let sort: SortModel
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

struct SortModel: Decodable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
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
        EmotionTag(rawValue: self.emotionResponse.firstEmotion ?? 0) ?? .default
    }
    
    var secondEmotionBinding: EmotionTag{
        EmotionTag(rawValue: self.emotionResponse.secondEmotion ?? Const.default) ?? .default
    }
    
    var myReactionBinding: UIImage{
        let reaction = self.emotionResponse.myEmotion
//        else {
//            return Image.emojiAdd
//        }
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
