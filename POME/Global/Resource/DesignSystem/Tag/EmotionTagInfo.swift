//
//  EmojiTagInfo.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import Foundation

enum EmotionTag: Int{
    case `default` = -1 //Const.default
    case happy
    case what
    case sad
}

private struct EmotionTagIcon{
    let firstEmotion: UIImage
    let secondEmotion: UIImage
}

extension EmotionTag{
    
    init?(tagValue: Int){
        self.init(rawValue: (tagValue - 100) / 100)
    }
    
    var message: String{
        switch self{
        case .happy:    return "행복해요"
        case .what:     return "모르겠어요"
        case .sad:      return "후회해요"
        default:        return "아직 감정을 남기지 않았어요"
        }
    }
    
    private var iconDescription: EmotionTagIcon{
        switch self{
        case .sad:      return EmotionTagIcon(firstEmotion: Image.emojiSad,
                                              secondEmotion: Image.reviewSad)
        case .what:     return EmotionTagIcon(firstEmotion: Image.emojiWhat,
                                              secondEmotion: Image.reviewWhat)
        case .happy:    return EmotionTagIcon(firstEmotion: Image.emojiHappy,
                                              secondEmotion: Image.reviewHappy)
        default:        return EmotionTagIcon(firstEmotion: Image.tagUnselect,
                                              secondEmotion: Image.tagUnselect)
        }
    }
    
    var firstEmotionImage: UIImage{
        self.iconDescription.firstEmotion
    }
    
    var secondEmotionImage: UIImage{
        self.iconDescription.secondEmotion
    }
    
    var tagBinding: Int{
        self.rawValue * 100 + 100
    }
}
