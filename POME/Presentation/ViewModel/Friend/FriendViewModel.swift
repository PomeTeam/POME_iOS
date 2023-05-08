//
//  FriendViewModel.swift
//  POME
//
//  Created by 박지윤 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol FriendViewModelInterface: BaseViewModel{
    var friends: [FriendsResponseModel] { get }
    var records: [RecordResponseModel] { get }
    var hasNextPage: Bool { get }
    var registerReactionCompleted: ((Int) -> Void)! { get }
    func registerReaction(id: Int, index: Int)
//    var hideRecordCompleted: () { get }
//    func hideRecord(index: Int)
}

class FriendViewModel: FriendViewModelInterface{

    var friends = [FriendsResponseModel]()
    var records = [RecordResponseModel]()
    var hasNextPage = false
    
    var registerReactionCompleted: ((Int) -> Void)!
    
    
    private let getFriendsUseCase: GetFriendsUseCaseInterface
    private let getAllFriendsRecordsUseCase: GetAllFriendsRecordsUseCaseInterface
    private let getFriendRecordsUseCase: GetFriendRecordsUseCaseInterface
    private let hideFriendRecordUseCase: HideRecordUseCaseInterface
    private let registerRecordReactionUseCase: RegisterReactionUseCaseInterface
    
    init(getFriendsUseCase: GetFriendsUseCaseInterface = GetFriendsUseCase(),
         getAllFriendsRecordsUseCase: GetAllFriendsRecordsUseCaseInterface = GetAllFriendsRecordsUseCase(),
         getFriendRecordsUseCase: GetFriendRecordsUseCaseInterface = GetFriendRecordsUseCase(),
         hideFriendRecordUseCase: HideRecordUseCaseInterface = HideRecordUseCase(),
         registerRecordReactionUseCase: RegisterReactionUseCaseInterface = RegisterReactionUseCase()) {
        self.getFriendsUseCase = getFriendsUseCase
        self.getAllFriendsRecordsUseCase = getAllFriendsRecordsUseCase
        self.getFriendRecordsUseCase = getFriendRecordsUseCase
        self.hideFriendRecordUseCase = hideFriendRecordUseCase
        self.registerRecordReactionUseCase = registerRecordReactionUseCase
    }
    
    private var friendIndex = 0
    
    private let pageRelay = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    struct Input{
        let refreshView: Observable<Void>
        let willPaging: Observable<Void>
        let friendCellIndex: Observable<Int>
    }
    
    struct Output{
        let reloadFriends: Observable<Void>
        let reloadRecords: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let friendsResponse = input.refreshView
            .flatMap{
                self.getFriendsUseCase.execute()
            }.share()
        
        let reloadCollectionView = friendsResponse
            .do{
                self.friends = $0
                self.pageRelay.accept(0)
            }.map{ _ in
                ()
            }
                
        input.willPaging
            .subscribe(onNext: {
                self.pageRelay.accept(1)
            }).disposed(by: disposeBag)
        
        input.friendCellIndex
            .subscribe(onNext: {
                self.friendIndex = $0
                self.pageRelay.accept(0)
            })
            .disposed(by: disposeBag)
                
                
        let requestPage = pageRelay
                .scan((0,0)){
                    $1 == 0 ? ($0.1, 0) : ($0.1, $0.1 + $1) //0인 경우 0 반환, 1인 경우 page + 1 반환
                }.map{
                    $0.1
                }
                .share()
        
        let recordsResponse = requestPage
            .flatMap{ [self] page in
                let pageModel = PageableModel(page: page)
                return friendIndex == 0
                ? self.getAllFriendsRecordsUseCase.execute(requestModel: pageModel)
                : self.getFriendRecordsUseCase.execute(
                    requestModel: GetFriendRecordsRequestValue(
                        friendId: self.friends[friendIndex - 1].friendUserId,
                        pageable: pageModel
                    )
                )
            }.share()
        
        let reloadTableView: Observable<Void> = recordsResponse
            .do(onNext: { [weak self] in
                self?.hasNextPage = !$0.last
                self?.records = $0.content
            })
            .map{ _ in () }
            
        
        return Output(
            reloadFriends: reloadCollectionView,
            reloadRecords: reloadTableView
        )
    }
    
    func registerReaction(id reactionId: Int, index: Int) {
        registerRecordReactionUseCase.execute(
            requestValue: RegisterReactionRequestValue(recordId: records[index].id, emotionId: reactionId)
        ).subscribe{ [weak self] in
            self?.records[index] = $0
            self?.registerReactionCompleted(index)
        }.disposed(by: disposeBag)
    }
}
