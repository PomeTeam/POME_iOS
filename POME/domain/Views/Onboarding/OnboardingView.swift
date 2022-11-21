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
    let kakao = UIImageView().then{
        $0.image = Image.kakao
    }
    let apple = UIImageView().then{
        $0.image = Image.apple
    }
    let startButton = DefaultButton(titleStr: "시작하기")
    
    override func hierarchy() {
        addSubview(logoImage)
        addSubview(logo)
        addSubview(slogan)
        
        addSubview(stack)
        stack.addArrangedSubview(kakao)
        stack.addArrangedSubview(apple)
        
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
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slogan.snp.bottom).offset(50)
        }
        kakao.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        apple.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(73)
            make.height.equalTo(45)
            make.top.equalTo(stack.snp.bottom).offset(16)
        }
    }
}
