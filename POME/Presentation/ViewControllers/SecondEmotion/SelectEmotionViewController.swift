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
    private var recordId: Int
    private var record: RecordDTO
    
    private let DEFAULT_INT: Int = -1
    private let DEFAULT_STRING: String = ""
    
    private let mainView: SelectEmotionView
    private let viewModel: SelectEmotionViewModel
    
    private typealias emotionViewType = SelectEmotionView.EmotionElementView
    
    init(type: SelectEmotionType, recordId: Int){
        self.type = type
        self.recordId = recordId
        self.record = RecordDTO(goalId: DEFAULT_INT, useComment: DEFAULT_STRING, useDate: DEFAULT_STRING, usePrice: DEFAULT_INT)
        
        mainView = SelectEmotionView(type: type)
        viewModel = PostSecondEmotionViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    init(type: SelectEmotionType, record: RecordDTO){
        self.type = type
        self.recordId = DEFAULT_INT
        self.record = record
        
        mainView = SelectEmotionView(type: type)
        viewModel = SelectEmotionViewModel()
        
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
        var output = SelectEmotionViewModel.Output.init(deselectEmotion: Driver<Int>.of(DEFAULT_INT),
                                                        selectEmotion: Driver<Int>.of(DEFAULT_INT),
                                                        ctaButtonActivate: Driver<Bool>.of(false),
                                                        registerStatusCode: Driver<BaseResponseStatus>.of(BaseResponseStatus.fail))
        switch type {
        case .First:
            let input = SelectEmotionViewModel.FirstInput(record: record,
                                                           happyEmotionSelect: mainView.happyEmotionView.rx.tapGesture().asObservable(),
                                                           whatEmotionSelect: mainView.whatEmotionView.rx.tapGesture().asObservable(),
                                                           sadEmotionSelect: mainView.sadEmotionView.rx.tapGesture().asObservable(),
                                                           ctaButtonTap: mainView.completeButton.rx.tap)
            output = viewModel.transform(input)
        case .Second:
            let input = SelectEmotionViewModel.SecondInput(record: recordId,
                                                           happyEmotionSelect: mainView.happyEmotionView.rx.tapGesture().asObservable(),
                                                           whatEmotionSelect: mainView.whatEmotionView.rx.tapGesture().asObservable(),
                                                           sadEmotionSelect: mainView.sadEmotionView.rx.tapGesture().asObservable(),
                                                           ctaButtonTap: mainView.completeButton.rx.tap)
            output = viewModel.transform(input)
        }
        
        
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
