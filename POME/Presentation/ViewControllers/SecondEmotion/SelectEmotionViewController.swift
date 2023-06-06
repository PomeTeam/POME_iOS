//
//  SelectEmotionViewController.swift
//  POME
//
//  Created by gomin on 2023/06/05.
//

import Foundation
import RxSwift
import RxCocoa


class SelectEmotionViewController: BaseViewController{
    
    private var type: SelectEmotionType
    
    private let mainView: SelectEmotionView
    private let viewModel: SelectEmotionViewModel
    
    private typealias emotionViewType = SelectEmotionView.EmotionElementView
    
    // First Emotion -> recordDTO
    init(type: SelectEmotionType, record: RecordDTO){
        self.type = type
        
        mainView = SelectEmotionView(type: type)
        viewModel = RecordFirstEmotionViewModel()
        viewModel.record = record
        
        super.init(nibName: nil, bundle: nil)
    }
    // Second Emotion -> recordId
    init(type: SelectEmotionType, recordId: Int){
        self.type = type
        
        mainView = SelectEmotionView(type: type)
        viewModel = PostSecondEmotionViewModel()
        viewModel.recordId = recordId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style(){
        super.style()
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
        let input = SelectEmotionViewModel.Input(happyEmotionSelect: mainView.happyEmotionView.rx.tapGesture().asObservable(),
                                                   whatEmotionSelect: mainView.whatEmotionView.rx.tapGesture().asObservable(),
                                                   sadEmotionSelect: mainView.sadEmotionView.rx.tapGesture().asObservable(),
                                                   ctaButtonTap: mainView.completeButton.rx.tap)
        let output = viewModel.transform(input)
        
        
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
        
        registerCompletion(output)
        
    }
    
    // 첫 번째 감정을 남긴 이후 -> generateRecord 완료
    // 두 번째 감정을 남긴 이후 -> registerSecondEmotion 완료
    private func registerCompletion(_ output: SelectEmotionViewModel.Output) {
        switch type {
        case .First:
            output.registerStatusCode.drive(onNext: { [weak self] status in
                if status == .success {
                    self?.navigationController?.pushViewController(RegisterSuccessViewController(type: .consume), animated: true)
                }
            }).disposed(by: disposeBag)
            
            etcButton.rx.tap
                .bind{ [weak self] in
                    self?.closeButtonDidClicked()
                }.disposed(by: disposeBag)
            
        case .Second:
            output.registerStatusCode.drive(onNext: { [weak self] status in
                if status == .success {
                    RecordObserver.shared.registerSecondEmotion.onNext(Void())
                    self?.navigationController?.pushViewController(RegisterSuccessViewController(type: .consume), animated: true)
                }
            }).disposed(by: disposeBag)
        }
    }
    // 첫 번째 감정 남기는 페이지 > '닫기' Click Event
    private func closeButtonDidClicked(){
        if type == .First {
            ImageAlert.quitRecord.generateAndShow(in: self).do{
                $0.completion = { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    
}
