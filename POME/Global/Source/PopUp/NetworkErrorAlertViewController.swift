//
//  NetworkErrorAlertViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/09.
//

import Foundation

struct NetworkAlert{
    static func show(in viewController: UIViewController, completion: @escaping () -> Void){
        let alert = NetworkErrorAlertViewController().then{
            $0.loadViewIfNeeded()
            $0.modalPresentationStyle = .overFullScreen
            $0.completion = {
                completion()
            }
        }
        viewController.navigationController?.present(alert, animated: false)
    }
}

class NetworkErrorAlertViewController: ImagePopUpViewController{
    
    init(){
        super.init(imageValue: Image.error,
                   titleText: "인터넷에 연결할 수 없어요",
                   messageText: "다시 시도하거나 네트워크 설정을 확인해주세요",
                   greenBtnText: "다시 시도",
                   grayBtnText: "취소")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpConstraint() {
        
        super.setUpConstraint()
        
        popupImage.snp.updateConstraints{
            $0.width.height.equalTo(60)
        }
    }
}

