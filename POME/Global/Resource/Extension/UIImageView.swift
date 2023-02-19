//
//  UIImageView.swift
//  POME
//
//  Created by gomin on 2023/02/18.
//

import Foundation

extension UIImageView {
    // MARK: Set Level Marshmallow
    func setMarshmallowImage(_ type: MarshmallowType, _ level: Int) {
        switch type {
        case .record:
            switch level {
            case 1:
                self.image = Image.marshmallowLevel1Pink
            case 2:
                self.image = Image.marshmallowLevel2Pink
            case 3:
                self.image = Image.marshmallowLevel3Pink
            case 4:
                self.image = Image.marshmallowLevel4Pink
            default:
                self.image = Image.marshmallowLock
            }
        case .emotion:
            switch level {
            case 1:
                self.image = Image.marshmallowLevel1Blue
            case 2:
                self.image = Image.marshmallowLevel2Blue
            case 3:
                self.image = Image.marshmallowLevel3Blue
            case 4:
                self.image = Image.marshmallowLevel4Blue
            default:
                self.image = Image.marshmallowLock
            }
        case .growth:
            switch level {
            case 1:
                self.image = Image.marshmallowLevel1Yellow
            case 2:
                self.image = Image.marshmallowLevel2Yellow
            case 3:
                self.image = Image.marshmallowLevel3Yellow
            case 4:
                self.image = Image.marshmallowLevel4Yellow
            default:
                self.image = Image.marshmallowLock
            }
        case .honest:
            switch level {
            case 1:
                self.image = Image.marshmallowLevel1Mint
            case 2:
                self.image = Image.marshmallowLevel2Mint
            case 3:
                self.image = Image.marshmallowLevel3Mint
            case 4:
                self.image = Image.marshmallowLevel4Mint
            default:
                self.image = Image.marshmallowLock
            }
       
        default:
            print("")
        }
    }
}
