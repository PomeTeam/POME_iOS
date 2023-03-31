//
//  RecordRegisterEmotionSelectViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

class RegisterFirstEmotionViewModel{
    
    private let createRecorUseCase: GenerateRecordUseCase
    private let emotionSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    struct Input{
        let happyEmotionSelect: TapObservable
        let whatEmotionSelect: TapObservable
        let sadEmotionSelect: TapObservable
        let ctaButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let deselectEmotion: Driver<Int>
        let selectEmotion: Driver<Int>
        let ctaButtonActivate: Driver<Bool>
    }
    
    init(createRecordUseCase: GenerateRecordUseCase = GenerateRecordUseCase()){
        self.createRecorUseCase = createRecordUseCase
    }
    
    func transform(input: Input) -> Output{

        input.happyEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.happy.tagBinding)
            }).disposed(by: disposeBag)
        
        input.whatEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.what.tagBinding)
            }).disposed(by: disposeBag)
        
        input.sadEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.sad.tagBinding)
            }).disposed(by: disposeBag)
        
        let emotionStorage = emotionSubject
            .scan((nil, nil)){
                ($0.1, $1)
            }.share()
        
        let deselectEmotion = emotionStorage
            .compactMap{
                $0.0
            }.asDriver(onErrorJustReturn: -1)
        
        let selectEmotion = emotionStorage
            .compactMap{
                $0.1
            }.asDriver(onErrorJustReturn: -1)
        
        //tagBinding용으로 observable 했기 때문에 api 통신할 때는 rawValue로 변환 연산 필요
        
        let ctaButtonActivate = emotionSubject
            .first()
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        

        return Output(deselectEmotion: deselectEmotion,
                      selectEmotion: selectEmotion,
                      ctaButtonActivate: ctaButtonActivate)
    }
    
    
}
