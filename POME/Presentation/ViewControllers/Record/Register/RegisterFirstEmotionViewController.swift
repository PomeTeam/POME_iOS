//
//  RegisterFirstEmotionViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterFirstEmotionViewController: BaseViewController{
    
    
    private typealias emotionViewType = RecordRegisterEmotionSelectView.FirstEmotionView
    private let mainView = RecordRegisterEmotionSelectView()
    private let viewModel = RegisterFirstEmotionViewModel()
    
    
    override func style(){
        super.style()
        setEtcButton(title: "닫기")
    }
    
    override func layout(){
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind(){
        
        let input = RegisterFirstEmotionViewModel.Input(happyEmotionSelect: mainView.happyEmotionView.rx.tapGesture().asObservable(),
                                                               whatEmotionSelect: mainView.whatEmotionView.rx.tapGesture().asObservable(),
                                                               sadEmotionSelect: mainView.sadEmotionView.rx.tapGesture().asObservable(),
                                                        ctaButtonTap: mainView.completeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.deselectEmotion
            .drive(onNext: { [weak self] emotionTag in
                if let emotion = EmotionTag(tagValue: emotionTag), let emotionView =  self?.mainView.emotionStackView.viewWithTag(emotion.tagBinding) as? emotionViewType{
                    emotionView.changeDeselectState()
                }
            }).disposed(by: disposeBag)
        
        output.selectEmotion
            .drive(onNext: { [weak self] emotionTag in
                if let emotion = EmotionTag(tagValue: emotionTag), let emotionView =  self?.mainView.emotionStackView.viewWithTag(emotion.tagBinding) as? emotionViewType{
                    emotionView.changeSelectState()
                }
            }).disposed(by: disposeBag)

        output.ctaButtonActivate
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        etcButton.rx.tap
            .bind{ [weak self] in
                self?.closeButtonDidClicked()
            }.disposed(by: disposeBag)
    }
    
    private func closeButtonDidClicked(){
        ImageAlert.quitRecord.generateAndShow(in: self).do{
            $0.completion = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
