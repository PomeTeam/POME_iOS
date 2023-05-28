//
//  OnBoardingView.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import Foundation
import UIKit

class OnboardingView: BaseView {
    let logoImage = UIImageView().then{
        $0.image = Image.splashImage
    }
    let logo = UIImageView().then{
        $0.image = Image.logoMint
    }
    let slogan = UIImageView().then{
        $0.image = Image.sloganMint
    }
    let stack = UIStackView().then{
        $0.spacing = 15
        $0.axis = .horizontal
    }
    let startButton = DefaultButton(titleStr: "시작하기")
    
    override func hierarchy() {
        addSubview(logoImage)
        addSubview(logo)
        addSubview(slogan)
        
        addSubview(startButton)
    }
    override func layout() {
        logoImage.snp.makeConstraints { make in
            make.width.height.equalTo(230)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(135)
        }
        logo.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(37)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImage.snp.bottom).offset(32)
        }
        slogan.snp.makeConstraints { make in
            make.width.equalTo(197)
            make.height.equalTo(19)
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(10)
        }
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(73)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.top.equalTo(slogan.snp.bottom).offset(73)
        }
    }
}
