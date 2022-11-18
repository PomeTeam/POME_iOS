//
//  ReactionInfo.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import Foundation
import UIKit

enum Reaction: Int, CaseIterable{
    case happy = 0 //rawValue로 index 값 할당
    case what
    case funny
    case flex
    case sad
    case smile
}

struct ReactionImage{
    let defaultImage: UIImage
    let blurImage: UIImage
}

extension Reaction{
    
    var toastMessage: String{
        switch self{
        case .happy:    return "좋아요!"
        case .what:     return "놀라워요!"
        case .funny:    return "메롱!"
        case .flex:     return "플렉스!"
        case .sad:      return "슬퍼요"
        case .smile:    return "웃겨요!"
        }
    }
    
    private var imageDescription: ReactionImage{
        switch self{
        case .smile:    return ReactionImage(defaultImage: Image.emojiSmile,
                                             blurImage: Image.emojiBlurSmile)
        case .flex:     return ReactionImage(defaultImage: Image.emojiFlex,
                                             blurImage: Image.emojiBlurFlex)
        case .funny:    return ReactionImage(defaultImage: Image.emojiFunny,
                                             blurImage: Image.emojiBlurFunny)
        case .happy:    return ReactionImage(defaultImage: Image.emojiHappy,
                                             blurImage: Image.emojiBlurHappy)
        case .what:     return ReactionImage(defaultImage: Image.emojiWhat,
                                             blurImage: Image.emojiBlurWhat)
        case .sad:      return ReactionImage(defaultImage: Image.emojiSad,
                                             blurImage: Image.emojiBlurSad)
        }
    }
    
    var defaultImage: UIImage{
        return self.imageDescription.defaultImage
    }
    
    var blurImage: UIImage{
        return self.imageDescription.blurImage
    }

}
