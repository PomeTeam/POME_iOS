//
//  RecordableViewModel.swift
//  POME
//
//  Created by 박소윤 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

protocol GoalSelectViewModel{
    func getGoalCount() -> Int
    func selectGoal(at index: Int)
    func getGoalTitle(at index: Int) -> String
}

protocol RecordButtonControl{
    associatedtype Output
    func controlEvent(_ tapEvent: ControlEvent<Void>) -> Driver<Output>
}

class RecordableViewModel: BaseViewModel{
    
    private var goals = [GoalResponseModel]()
    
    private let disposeBag = DisposeBag()
    private let recordCommentPlaceholder = "소비에 대한 감상을 적어주세요 (150자)"
    
    var requestObservable: Observable<(GoalResponseModel, String, Int, String)>!
    private let goalSubject: BehaviorSubject<GoalResponseModel>
    private let consumeDateSubject: BehaviorSubject<String>
    private let getGoalUseCase: GetGoalUseCaseInterface
    
    init(defaultGoal: GoalResponseModel, defaultDate: String, getGoalUseCase: GetGoalUseCaseInterface = GetGoalUseCase()){
        goalSubject = BehaviorSubject(value: defaultGoal)
        consumeDateSubject = BehaviorSubject(value: defaultDate)
        self.getGoalUseCase = getGoalUseCase
    }
    
    struct Input{
        let consumePrice: Observable<String>
        let consumeComment: Observable<String>
    }
    
    struct Output{
        let highlightCalendarIcon: Driver<Bool>
        let ctaButtonActivate: Driver<Bool>
        let goalBinding: Driver<String>
        let dateBinding: Driver<String>
        let priceBinding: Driver<String>
        let commentBinding: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
            
        let goalBinding = goalSubject
            .map{
                $0.name
            }.asDriver(onErrorJustReturn: "")
        
        let priceBinding = input.consumePrice
            .map{ self.priceConvertToDecimalFormat(text: $0 )}
            .asDriver(onErrorJustReturn: "0")
        
        let price = input.consumePrice
            .map{
                Int($0.replacingOccurrences(of: ",", with: "")) ?? 0
            }
        
        let dateBinding = consumeDateSubject
            .asDriver(onErrorJustReturn: PomeDateFormatter.getTodayDate())
        
        //TODO: 글자수 제한, placeholder 등 제한 필요
        let commentBinding = input.consumeComment
            .asDriver(onErrorJustReturn: "")
            
        
        let highlightCalendarIcon = consumeDateSubject
            .map{ !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        requestObservable = Observable.combineLatest(goalSubject,
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
                      ctaButtonActivate: canMoveNext,
                      goalBinding: goalBinding,
                      dateBinding: dateBinding,
                      priceBinding: priceBinding,
                      commentBinding: commentBinding)
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

extension RecordableViewModel: CalendarViewModel, GoalSelectViewModel{
    
    func viewWillAppear(){
        getGoalUseCase.execute()
            .subscribe{ [weak self] in
                self?.goals = $0
            }.disposed(by: disposeBag)
    }
    
    func getGoalCount() -> Int{
        goals.count
    }
    
    func getGoalTitle(at index: Int) -> String{
        goals[index].name
    }
    
    func selectGoal(at index: Int) {
        goalSubject.onNext(goals[index])
    }
    
    func selectConsumeDate(_ date: String) {
        consumeDateSubject.onNext(date)
    }
}
