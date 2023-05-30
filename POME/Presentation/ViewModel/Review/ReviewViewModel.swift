//
//  ReviewViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

/*
 목표 리스트 조회
 목표에 해당하는 기록 조회
 기록 삭제
 감정 필터링
 */


//protocol ReviewViewModelInterface: BaseViewModel, ModifyRecordInterface{
//    var goals: [GoalResponseModel] { get }
//    var records: [RecordResponseModel] { get }
//}

final class ReviewViewModel: GoalWithRecordViewModel {

    private let getRecordsUseCase: GetRecordInReviewUseCaseInterface
    private var emotionFilter: Review.EmotionFiltering = (nil, nil)
    
    init(getRecordsUseCase: GetRecordInReviewUseCaseInterface = GetRecordInReviewUseCase()){
        self.getRecordsUseCase = getRecordsUseCase
    }
    
    struct Input{
        let selectedGoalIndex: Observable<Int>
        let filteringEmotion: Observable<Review.EmotionFiltering>
    }
    
    struct Output{}
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
        input.selectedGoalIndex
            .subscribe{ [weak self] in
                self?.selectedGoalIndex = $0
                self?.initializeStateAndRequestRecord()
            }.disposed(by: disposeBag)
        
        input.filteringEmotion
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.emotionFilter = $0
                self?.initializeStateAndRequestRecord()
                self?.requestRecords()
            }).disposed(by: disposeBag)
        
        return Output()
    }
    
    override func requestRecords(){
        let recordResponse = getRecordsUseCase
            .execute(
                goalId: goals[self.selectedGoalIndex].id,
                requestValue: GetRecordInReviewRequestModel(
                    firstEmotion: emotionFilter.first,
                    secondEmotion: emotionFilter.second,
                    pageable: PageableModel(page: page)
                )
            ).share()
        
        recordResponse
            .do(onNext: {
                self.hasNextPage = !$0.last
            }).subscribe(onNext: { [weak self] in
                if $0.page == 0 {
                    self?.records = $0.content
                } else {
                    self?.records.append(contentsOf: $0.content)
                }
                self?.reloadTableView.accept(Void())
            }).disposed(by: disposeBag)
    }

    func requestNextPage(){
        page += 1
        requestRecords()
    }
}
