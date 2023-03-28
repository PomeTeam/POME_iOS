//
//  RecordRegisterContentViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa

class RecordRegisterContentViewModel{
    
    private let createRecordUseCase: CreateRecordUseCase
    
    struct Input{
        let cateogrySelect: Observable<String>
        let consumeDateSelect: Observable<String>
        let priceTextField: Observable<String>
        let detailTextView: Observable<String>
        let detailTextViewplaceholder: String
        let nextButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let highlightCalendarIcon: Driver<Bool>
        let canMoveNext: Driver<Bool>
    }
    
    init(createRecordUseCase: CreateRecordUseCase){
        self.createRecordUseCase = createRecordUseCase
    }
    
    func transform(input: Input) -> Output{
        
        let requestObservable = Observable.combineLatest(input.cateogrySelect,
                                                         input.consumeDateSelect,
                                                         input.priceTextField,
                                                         input.detailTextView)
        
        let highlightCalendarIcon = input.consumeDateSelect
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let canMoveNext = requestObservable
            .map{ category, date, price, detail in
                return !category.isEmpty && !date.isEmpty
                && !price.isEmpty && Int(price.replacingOccurrences(of: ",", with: ""))! > 0
                && detail != input.detailTextViewplaceholder
                && !detail.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        return Output(highlightCalendarIcon: highlightCalendarIcon,
                      canMoveNext: canMoveNext)
    }
}


//MARK: - New ver.
@objc protocol CalendarViewModel{
    @objc optional func selectConsumeDate(_ date: String)
    @objc optional func selectConsumeDate(tag: Int, _ date: String)
}

protocol GoalSelectViewModel{
    func selectGoal(at index: Int)
}

class RecordableViewModel: BaseViewModel, CalendarViewModel, GoalSelectViewModel{
    
    private let recordCommentPlaceholder = "소비에 대한 감상을 적어주세요 (150자)"
    private var goals = [GoalResponseModel]()
    
    private let goalSubject: BehaviorSubject<GoalResponseModel>
    private let consumeDateSubject: BehaviorSubject<String>
    private let recordRequestManager = RecordRegisterRequestManager.shared
    
    init(defaultGoal: GoalResponseModel, defaultDate: String){
        goalSubject = BehaviorSubject(value: defaultGoal)
        consumeDateSubject = BehaviorSubject(value: defaultDate)
    }
    
    struct Input{
        let consumePrice: Observable<String>
        let consumeComment: Observable<String>
    }
    
    struct Output{
        let highlightCalendarIcon: Driver<Bool>
        let canMoveNext: Driver<Bool>
        let goalBinding: Driver<String>
        let dateBinding: Driver<String>
        let priceBinding: Driver<String>
        let commentBinding: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
            
        let goalBinding = goalSubject
            .do{ [weak self] in
                self?.recordRequestManager.goalId = $0.id
            }.map{
                $0.name
            }.asDriver(onErrorJustReturn: "")
        
        let priceBinding = input.consumePrice
            .map{ self.priceConvertToDecimalFormat(text: $0 )}
            .asDriver(onErrorJustReturn: "0")
        
        let price = input.consumePrice
            .map{
                Int($0.replacingOccurrences(of: ",", with: "")) ?? 0
            }.do{ [weak self] in
                self?.recordRequestManager.price = String($0) //나중에 requestmanager price type int로 바꾸기
            }
        
        let dateBinding = consumeDateSubject
            .do{ [weak self] in
                self?.recordRequestManager.consumeDate = $0
            }.asDriver(onErrorJustReturn: PomeDateFormatter.getTodayDate())
        
        //TODO: 글자수 제한, placeholder 등 제한 필요
        let commentBinding = input.consumeComment
            .do{ [weak self] in
                self?.recordRequestManager.detail = $0
            }.asDriver(onErrorJustReturn: "")
            
        
        let highlightCalendarIcon = consumeDateSubject
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let requestObservable = Observable.combineLatest(goalSubject,
                                                         consumeDateSubject,
                                                         price,
                                                         input.consumeComment)

        
        let canMoveNext = requestObservable
            .map{ goal, date, price, comment in
                return !date.isEmpty
                        && price > 0
                        && comment != self.recordCommentPlaceholder
                        && !comment.isEmpty
            }.asDriver(onErrorJustReturn: false)
        
        return Output(highlightCalendarIcon: highlightCalendarIcon,
                      canMoveNext: canMoveNext,
                      goalBinding: goalBinding,
                      dateBinding: dateBinding,
                      priceBinding: priceBinding,
                      commentBinding: commentBinding)
        
    }
    
    func selectGoal(at index: Int) {
        goalSubject.onNext(goals[index])
    }
    
    func selectConsumeDate(_ date: String) {
        consumeDateSubject.onNext(date)
    }
    
    private func priceConvertToDecimalFormat(text: String) -> String{
        
        let formatter = NumberFormatter().then{
            $0.numberStyle = .decimal // 1,000,000
            $0.locale = Locale.current
            $0.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        }
        
        let removeComma = text.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        guard let formattedNumber = formatter.number(from: removeComma),
                let formattedString = formatter.string(from: formattedNumber) else{
            return text.isEmpty ? "0" : ""
        }
        return formattedString
    }
}
