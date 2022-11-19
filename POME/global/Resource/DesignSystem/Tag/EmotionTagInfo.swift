//
//  EmojiTagInfo.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import Foundation

//TODO: emotion으로 이름 변경
enum EmotionTag{
    case sad
    case what
    case happy
}

enum EmotionTime{
    case first
    case second
}

private struct EmotionTagIcon{
    let firstEmotion: UIImage
    let secondEmotion: UIImage
}

extension EmotionTag{
    
    var message: String{
        switch self{
        case .sad:      return "후회해요"
        case .what:     return "모르겠어요"
        case .happy:    return "행복해요"
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
        }
    }
    
    var firstEmotion: UIImage{
        return self.iconDescription.firstEmotion
    }
    
    var secondEmotion: UIImage{
        return self.iconDescription.secondEmotion
    }
}
