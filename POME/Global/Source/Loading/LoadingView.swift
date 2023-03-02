//
//  LoadingView.swift
//  POME
//
//  Created by 박소윤 on 2023/02/13.
//

import Foundation

class LoadingView: NSObject {
    
    private static let shared = LoadingView()
    
    private override init() { }
    
    private var backgroundView: UIView?
    private var popupView: UIImageView?
    
    class func hide() {
        if let popupView = shared.popupView, let backgroundView = shared.backgroundView {
            popupView.stopAnimating()
            popupView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }

    class func show(backgroundColor: UIColor = Color.popUpBackground) {
        
        let backgroundView = UIView()
        let popupView = UIImageView()
                                                                              
        popupView.animationImages = LoadingView.getAnimationImageArray()
        popupView.animationDuration = 1.1 // 로딩이 이 timeInterval 값에 따라서 시간의 값이 달라집니다 원하는 반복 시간을 설정해주세요
        popupView.animationRepeatCount = 0 // 반복 될 횟수를 입력 default는 0이고 default인 경우에는 무한 반복
        
        if let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first {
            
            window.addSubview(backgroundView)
            backgroundView.addSubview(popupView)
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = backgroundColor
            
            popupView.snp.makeConstraints{
                $0.width.height.equalTo(72)
                $0.centerX.centerY.equalToSuperview()
            }
            
            popupView.startAnimating()
                        
            shared.backgroundView?.removeFromSuperview()
            shared.popupView?.removeFromSuperview()
            shared.backgroundView = backgroundView
            shared.popupView = popupView
        }
    }

    private class func getAnimationImageArray() -> [UIImage] {
        var animationArray = [UIImage]()
        for i in 1...38{
            animationArray.append(UIImage(named: "loading_\(i)")!)
        }
        return animationArray
    }
}
