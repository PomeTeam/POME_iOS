//
//  SelectEmotionViewModel.swift
//  POME
//
//  Created by gomin on 2023/06/06.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

/* 첫 번째 감정과 두 번째 감정을 남길 때 사용되는 ViewModel입니다.
 
     * 공통되는 부분
     1) Input (happyEmotionSelect, whatEmotionSelect, sadEmotionSelect, ctaButtonTap)
     2) Output (deselectEmotion, selectEmotion, ctaButtonActivate, registerStatusCode)
 
     * 다른 부분
     첫 번째 감정: recordDTO
     두 번째 감정: recordId
     -> Override register logic
 */

class SelectEmotionViewModel{
    
    let emotionSubject = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    private let DEFAULT_INT: Int = -1
    private let DEFAULT_STRING: String = ""
    
    var recordId: Int
    var record: RecordDTO
    
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
        let registerStatusCode: Driver<BaseResponseStatus>
    }
    
    init(){
        recordId = DEFAULT_INT
        record = RecordDTO(goalId: DEFAULT_INT, useComment: DEFAULT_STRING, useDate: DEFAULT_STRING, usePrice: DEFAULT_INT)
    }
    
    func transform(_ input: Input) -> Output{

        setEmotionSubjects(input.happyEmotionSelect, input.whatEmotionSelect, input.sadEmotionSelect)
        
        let emotionStorage = emotionSubject
            .scan((nil, nil)){
                ($0.1, $1)
            }.share()
        
        let deselectEmotion = getDeselectEmotion(emotionStorage)
        let selectEmotion = getSelectEmotion(emotionStorage)
        let ctaButtonActivate = getCTAButtonActivate(emotionSubject)
        let registerStatusCode = register(input, selectEmotion)
        

        return Output(deselectEmotion: deselectEmotion,
                      selectEmotion: selectEmotion,
                      ctaButtonActivate: ctaButtonActivate,
                      registerStatusCode: registerStatusCode)
    }
    
    private func setEmotionSubjects(_ happyEmotionSelect: TapObservable, _ whatEmotionSelect: TapObservable, _ sadEmotionSelect:TapObservable) {
        happyEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.happy.tagBinding)
            }).disposed(by: disposeBag)
        
        whatEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.what.tagBinding)
            }).disposed(by: disposeBag)
        
        sadEmotionSelect
            .subscribe(onNext: { [weak self] _ in
                self?.emotionSubject.onNext(EmotionTag.sad.tagBinding)
            }).disposed(by: disposeBag)
    }
    
    private func getDeselectEmotion(_ emotionStorage: Observable<(Int?, Int?)>) -> Driver<Int> {
        let deselectEmotion = emotionStorage
            .compactMap{
                $0.0
            }.asDriver(onErrorJustReturn: -1)
        return deselectEmotion
    }
    private func getSelectEmotion(_ emotionStorage: Observable<(Int?, Int?)>) -> Driver<Int> {
        let selectEmotion = emotionStorage
            .compactMap{
                $0.1
            }.asDriver(onErrorJustReturn: -1)
        return selectEmotion
    }
    private func getCTAButtonActivate(_ emotionSubject: PublishSubject<Int>) -> Driver<Bool> {
        let ctaButtonActivate = emotionSubject
            .first()
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        return ctaButtonActivate
    }
    
    // Need Override
    func register(_ input: Input, _ selectEmotion: Driver<Int>) -> Driver<BaseResponseStatus> {
        return Driver<BaseResponseStatus>.of(BaseResponseStatus.fail)
    }
    
    
}
