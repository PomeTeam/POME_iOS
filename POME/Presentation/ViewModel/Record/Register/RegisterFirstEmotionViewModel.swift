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
    
    private let generateRecordUseCase: GenerateRecordUseCase
    private let emotionSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    struct Input{
        let record: RecordDTO
        let happyEmotionSelect: TapObservable
        let whatEmotionSelect: TapObservable
        let sadEmotionSelect: TapObservable
        let ctaButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let deselectEmotion: Driver<Int>
        let selectEmotion: Driver<Int>
        let ctaButtonActivate: Driver<Bool>
        let registerStatusCode: Driver<Int>
    }
    
    init(generateRecorUseCase: GenerateRecordUseCase = GenerateRecordUseCase()){
        self.generateRecordUseCase = generateRecorUseCase
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
        
        let ctaButtonActivate = emotionSubject
            .first()
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        

        let registerStatusCode = input.ctaButtonTap
            .withLatestFrom(selectEmotion)
            .compactMap{
                EmotionTag(tagValue: $0)?.rawValue
            }.map{ emotion in
                GenerateRecordRequestModel(emotionId: emotion,
                                           goalId: input.record.goalId,
                                           useComment: input.record.useComment,
                                           useDate: input.record.useDate,
                                           usePrice: input.record.usePrice)
            }.flatMap{
                self.generateRecordUseCase.execute(requestValue: $0)
            }.asDriver(onErrorJustReturn: 404)
        

        return Output(deselectEmotion: deselectEmotion,
                      selectEmotion: selectEmotion,
                      ctaButtonActivate: ctaButtonActivate,
                      registerStatusCode: registerStatusCode)
    }
    
    
}
