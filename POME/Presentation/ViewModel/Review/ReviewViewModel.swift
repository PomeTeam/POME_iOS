//
//  ReviewViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewViewModel: BaseViewModel{
    
    private let getGoalsUseCase: GetGoalUseCaseInterface
    private let getRecordsUseCase: GetGoalUseCaseInterface
    private let deleteRecordUseCase: GetGoalUseCaseInterface
    
    init(getGoalsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         getRecordsUseCase: GetGoalUseCaseInterface = GetGoalUseCase(),
         deleteRecordUseCase: GetGoalUseCaseInterface = GetGoalUseCase()){
        self.getGoalsUseCase = getGoalsUseCase
        self.getRecordsUseCase = getRecordsUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    private var goals = [GoalResponseModel]()
    private var records = [RecordResponseModel]()
    private var selectedGoal: Int!
    
    private let selectGoalSubject = BehaviorSubject<Int>(value: 0)
    private let firstEmotionSubject = BehaviorSubject<Int?>(value: nil)
    private let secondEmotionSubject = BehaviorSubject<Int?>(value: nil)
    private let filteringConditionSubejct = BehaviorSubject<(Int?, Int?)>(value: (nil, nil))
    
    struct Input{
        
    }
    
    struct Output{
//        let showEmptyView: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output{
        
        /*
         1. goal 조회
         
         */
        
        
        
        return Output()
    }
    
    
}

extension ReviewViewModel{
    
    
    /*
     상단에서 아래로 스와이플 할 경우에만 데이터 reload 시키는 건 어떤지..?
     */
    
    func viewDidLoad(){
        
    }
    
    func viewWillAppear(){
        //목표 조회 api 호출
    }
    
    func selectGoal(at index: Int){
        
    }
    
    func selectFirstEmotion(){
        
    }
    
    func selectSecondEmotion(){
        
    }
    
    func initializeFilterCondtion(){
        
    }
    
    func requestNextPage(){
        
    }
    
    func getGoalsCount() -> Int{
        goals.count == 0 ? 1 : goals.count
    }
    
    func getRecordsCount() -> Int{
        records.count
    }
    
    func getRecord(at index: Int) -> RecordResponseModel{
        records[index]
    }
    
    func hasNextPage() -> Bool{
        true
    }
}
