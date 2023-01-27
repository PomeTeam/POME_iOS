//
//  ReactionStyle.swift
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

struct ReactionIcon{
    let toastMessageIcon: UIImage = Image.toast
    let defaultIcon: UIImage
    let blurIcon: UIImage
    let selectIcon: UIImage
    let unselectIcon: UIImage
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
    
    private var imageDescription: ReactionIcon{
        switch self{
        case .smile:    return ReactionIcon(defaultIcon: Image.emojiSmile,
                                            blurIcon: Image.emojiBlurSmile,
                                            selectIcon: Image.emojiSmileSelect,
                                            unselectIcon: Image.emojiSmileUnSelect)
            
        case .flex:     return ReactionIcon(defaultIcon: Image.emojiFlex,
                                            blurIcon: Image.emojiBlurFlex,
                                            selectIcon: Image.emojiFlexSelect,
                                            unselectIcon: Image.emojiFlexUnSelect)
            
        case .funny:    return ReactionIcon(defaultIcon: Image.emojiFunny,
                                            blurIcon: Image.emojiBlurFunny,
                                            selectIcon: Image.emojiFunnySelect,
                                            unselectIcon: Image.emojiFunnyUnSelect)
            
        case .happy:    return ReactionIcon(defaultIcon: Image.emojiHappy,
                                            blurIcon: Image.emojiBlurHappy,
                                            selectIcon: Image.emojiHappySelect,
                                            unselectIcon: Image.emojiHappyUnSelect)
            
        case .what:     return ReactionIcon(defaultIcon: Image.emojiWhat,
                                            blurIcon: Image.emojiBlurWhat,
                                            selectIcon: Image.emojiWhatSelect,
                                            unselectIcon: Image.emojiWhatUnSelect)
            
        case .sad:      return ReactionIcon(defaultIcon: Image.emojiSad,
                                            blurIcon: Image.emojiBlurSad,
                                            selectIcon: Image.emojiSadSelect,
                                            unselectIcon: Image.emojiSadUnSelect)
        }
    }
    
    var toastMessageImage: UIImage{
        self.imageDescription.toastMessageIcon
    }
    
    var defaultImage: UIImage{
        return self.imageDescription.defaultIcon
    }
    
    var blurImage: UIImage{
        return self.imageDescription.blurIcon
    }
    
    var selectImage: UIImage{
        return self.imageDescription.selectIcon
    }
    
    var unselectImage: UIImage{
        return self.imageDescription.unselectIcon
    }
}
