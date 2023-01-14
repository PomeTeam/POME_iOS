//
//  AlertInfo.swift
//  POME
//
//  Created by 박지윤 on 2023/01/13.
//

import Foundation

enum ImageAlert{
    case deleteInProgressGoal
    case deleteRecord
    case quitRecord
    case deleteEndGoal
    case deleteFriend
}

extension ImageAlert{

    struct ImageAlertDescription{
        let image: UIImage
        let title: String
        let message: String
        let greenButtonTitle: String
        let greyButtonTitle: String
    }

    func generateAndShow(in: UIViewController) -> ImagePopUpViewController{
        
        return ImagePopUpViewController(imageValue: self.image,
                                        titleText: self.title,
                                        messageText: self.message,
                                        greenBtnText: self.greenButtonTitle,
                                        grayBtnText: self.greyButtonTitle)
    }
    
    private var description: ImageAlertDescription{
        switch self{
        case .deleteInProgressGoal:     return ImageAlertDescription(image: Image.trashGreen,
                                                                     title: "목표를 삭제하시겠어요?",
                                                                     message: "해당 목표에서 작성한 기록도 모두 삭제돼요",
                                                                     greenButtonTitle: "삭제할게요",
                                                                     greyButtonTitle: "아니요")
            
        case .deleteRecord:             return ImageAlertDescription(image: Image.trashGreen,
                                                                     title: "기록을 삭제하시겠어요?",
                                                                     message: "삭제한 내용은 다시 되돌릴 수 없어요",
                                                                     greenButtonTitle: "삭제할게요",
                                                                     greyButtonTitle: "아니요")
            
        case .quitRecord:               return ImageAlertDescription(image: Image.penMint,
                                                                     title: "작성을 그만 두시겠어요?",
                                                                     message: "지금까지 작성한 내용은 모두 사라져요",
                                                                     greenButtonTitle: "그만 둘래요",
                                                                     greyButtonTitle: "이어서 쓸래요")
            
        case .deleteEndGoal:            return ImageAlertDescription(image: Image.trashGreen,
                                                                     title: "종료된 목표를 삭제할까요?",
                                                                     message: "종료된 목표를 삭제할까요?",
                                                                     greenButtonTitle: "삭제할게요",
                                                                     greyButtonTitle: "아니요")
            
        case .deleteFriend:             return ImageAlertDescription(image: Image.trashPink,
                                                                     title: "친구를 삭제하시겠어요?",
                                                                     message: "친구의 씀씀이를 더 이상 볼 수 없어요",
                                                                     greenButtonTitle: "삭제할게요",
                                                                     greyButtonTitle: "아니요")
        }
    }
    
    private var image: UIImage{
        self.description.image
    }
    
    private var title: String{
        self.description.title
    }
    
    private var message: String{
        self.description.message
    }
    
    private var greenButtonTitle: String{
        self.description.greenButtonTitle
    }
    
    private var greyButtonTitle: String{
        self.description.greyButtonTitle
    }
}

//MARK: - TextAlert
enum TextAlert{
    
}
