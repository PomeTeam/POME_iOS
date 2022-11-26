//
//  SecondEmotionViewController.swift
//  POME
//
//  Created by gomin on 2022/11/26.
//

import UIKit

class SecondEmotionViewController: BaseViewController {

    var secondEmotionView: SecondEmotionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func style() {
        super.style()
        
    }
    override func layout() {
        super.layout()
        
        secondEmotionView = SecondEmotionView()
        self.view.addSubview(secondEmotionView)
        secondEmotionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        let selectHappyGesture = UITapGestureRecognizer(target: self, action: #selector(happyEmotionDidTap))
        let selectWhatGesture = UITapGestureRecognizer(target: self, action: #selector(whatEmotionDidTap))
        let selectSadGesture = UITapGestureRecognizer(target: self, action: #selector(sadEmotionDidTap))
        
        secondEmotionView.happyEmoji.addGestureRecognizer(selectHappyGesture)
        secondEmotionView.whatEmoji.addGestureRecognizer(selectWhatGesture)
        secondEmotionView.sadEmoji.addGestureRecognizer(selectSadGesture)
        
        secondEmotionView.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func happyEmotionDidTap(){
        secondEmotionView.happyEmoji.isSelected.toggle()
        secondEmotionView.whatEmoji.isSelected = false
        secondEmotionView.sadEmoji.isSelected = false
        isButtonActivate()
    }
    @objc func whatEmotionDidTap(){
        secondEmotionView.happyEmoji.isSelected = false
        secondEmotionView.whatEmoji.isSelected.toggle()
        secondEmotionView.sadEmoji.isSelected = false
        isButtonActivate()
    }
    @objc func sadEmotionDidTap(){
        secondEmotionView.happyEmoji.isSelected = false
        secondEmotionView.whatEmoji.isSelected = false
        secondEmotionView.sadEmoji.isSelected.toggle()
        isButtonActivate()
    }
    @objc func completeButtonDidTap(){
        self.navigationController?.popViewController(animated: true)
    }
    func isButtonActivate() {
        let isActivate = secondEmotionView.happyEmoji.isSelected || secondEmotionView.whatEmoji.isSelected || secondEmotionView.sadEmoji.isSelected ? true : false
        secondEmotionView.completeButton.isActivate(isActivate)
    }
}
