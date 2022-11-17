//
//  EmojiToastView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

enum Reaction{
    case smile
    case flex
    case funny
    case happy
    case what
    case sad
}

struct ReactionImage{
    let defaultImage: UIImage
    let blurImage: UIImage
}

extension Reaction

class ReactionToastView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
