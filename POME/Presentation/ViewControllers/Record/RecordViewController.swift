//
//  RecordViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//
import UIKit
import CloudKit
import RxSwift
import RxCocoa

class RecordViewController: BaseTabViewController {
    var recordView: RecordView!
    let viewModel = RecordTabViewModel()
    
    private let goalRelay = BehaviorRelay<Int>(value: 0)
    private var selectedGoalIndex: Int{
        goalRelay.value
    }
    
    private let INFO_SECTION = 0
    private let COUNT_OF_NOT_RECORD_CELL = 3 //record 이외 UI 구성하는 cell 3개 존재
    
    private var goalCategoryTableViewCell: GoalCategoryTableViewCell?{
        recordView.recordTableView.cellForRow(at: [INFO_SECTION,0], cellType: GoalCategoryTableViewCell.self)
    }
    
    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 3
    }
    
    
    // GetGoal control
    private var isFirstLoad = true
    // Goal Content
    var goalContent: [GoalResponseModel] = []
//    var categorySelectedIdx = 0
    // Records
    var recordsOfGoal: [RecordResponseModel] = []
    var noSecondEmotionRecords: [RecordResponseModel] = []
    // Page
    var recordPage: Int?
    // Cell Height
    var expendingCellContent = ExpandingTableViewCellContent()
    // Refresh Control
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshData()
    }
    
    override func style() {
        super.style()
        
        recordView = RecordView()
        recordView.recordTableView.delegate = self
        recordView.recordTableView.dataSource = self
    }
    override func layout() {
        super.layout()
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 83
        var writeButtonLoc = -(tabBarHeight + 16)
        
        recordView.writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(writeButtonLoc)
        }
        
        self.view.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        initRefresh()
        
        recordView.writeButton.rx.tap
            .bind {self.writeButtonDidTap()}
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        
        GoalObserver.shared.generateGoal
            .subscribe{ [weak self] _ in
                self?.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        GoalObserver.shared.deleteGoal
            .subscribe{ [weak self] _ in
                self?.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        RecordObserver.shared.deleteRecord
            .subscribe{ [weak self] _ in
                self?.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        RecordObserver.shared.generateRecord
            .subscribe{ _ in
                self.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        RecordObserver.shared.registerSecondEmotion
            .subscribe{ _ in
                self.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        viewModel.deleteRecordSubject
            .subscribe{
                self.recordView.recordTableView.deleteRows(at: [[self.INFO_SECTION, $0 + self.COUNT_OF_NOT_RECORD_CELL]], with: .fade)
                self.showEmptyView()
            }.disposed(by: disposeBag)
        
        viewModel.modifyRecordSubject
            .subscribe{
                self.recordView.recordTableView.reloadRows(at: [[self.INFO_SECTION, $0 + self.COUNT_OF_NOT_RECORD_CELL]], with: .none)
            }.disposed(by: disposeBag)
        
        //현재 포커스인 목표가 삭제되었을 경우, 0번째 인덱스로 선택 변경
        viewModel.changeGoalSelect
            .subscribe{ [weak self] _ in
                if let cell = self?.goalCategoryTableViewCell {
                    self?.collectionView(cell.goalCollectionView, didSelectItemAt: [0,0])
                }
            }.disposed(by: disposeBag)
        
        viewModel.reloadTableView
            .subscribe{ [weak self] _ in
                self?.stopRefreshingOrPaging()
                self?.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.transform(RecordTabViewModel.Input(
            selectedGoalIndex: goalRelay.asObservable())
        )
        
    }
    
    private func stopRefreshingOrPaging(){
//        isLoading = false
//        if isRefreshing {
//            recordView.recordTableView.refreshControl?.endRefreshing()
//        }
    }
    
    private func reloadData(){
        recordView.recordTableView.reloadData()
        goalCategoryTableViewCell?.goalCollectionView.reloadData()
        showEmptyView()
    }
    
    private func showEmptyView(){
        viewModel.records.isEmpty || viewModel.records.isEmpty
        ? EmptyView(self.recordView.recordTableView).showEmptyView(Image.noting, "기록한 씀씀이가 없어요")
        : EmptyView(self.recordView.recordTableView).hideEmptyView()
    }
    
    // MARK: - Actions
    // 알림 페이지 연결 제거
    override func topBtnDidClicked() {
//        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    @objc func writeButtonDidTap() {
        viewModel.goals.isEmpty ? showNoGoalContentsWarning() : moveToGenerateRecord()
    }
    
    @objc func finishGoalButtonDidTap(_ sender: GoalTapGesture) {
        /*
         7일이전 기록 있을 때 -> 아직 돌아보지 않은 기록이 있어요 바텀시트 띄우고 & 종료 페이지 진입 불가
         7일 이전 기록은 없으나 2차감정 기록을 하지 않았을 때 -> 아직 돌아보지 않은 기록이 있어요 바텀시트 띄우기 & 종료 페이지 진입 불가
         모든 감정기록 완료했을 때 -> 종료페이지 진입
         */
        let isSecondEmotionNeeded = !viewModel.records.isEmpty || !(viewModel.noSecondEmotionRecords == 0)
        isSecondEmotionNeeded ? showNoSecondEmotionWarning() : moveToAllRecords(sender)
    }
    @objc func addGoalButtonDidTap() {
        viewModel.goals.count < 10 ? moveToGenerateGoalDate() : cannotAddGoalWarning()
    }
    
    @objc func alertGoalMenuButtonDidTap(_ sender: GoalTapGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteInProgressGoal.generateAndShow(in: self)
            dialog.completion = {
                self.viewModel.deleteGoal()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
//    // MARK: 더보기 버튼 - Dynamic Cell Height Method
//    @objc func viewMoreButtonDidTap(_ sender: IndexPathTapGesture) {
//        let content = expendingCellContent
//        content.expanded = !content.expanded
//        self.recordView.recordTableView.reloadRows(at: [sender.data], with: .automatic)
//    }
    
    // MARK: Warning Sheets
    func showNoSecondEmotionWarning() {
        let sheet = RecordBottomSheetViewController(Image.penPink,
                                                    "아직 돌아보지 않은 기록이 있어요!",
                                                    "씀씀이 기록 후 일주일 뒤에\n감정을 돌아보고 목표를 종료할 수 있어요").show(in: self)
    }
    func cannotAddEmotionWarning() {
        let sheet = RecordBottomSheetViewController(Image.penPink, "아직은 감정을 기록할 수 없어요", "일주일이 지나야 감정을 남길 수 있어요\n나중에 다시 봐요!").show(in: self)
    }
    func cannotAddGoalWarning() {
        let sheet = RecordBottomSheetViewController(Image.ten, "목표는 10개를 넘을 수 없어요", "포미는 사용자가 무리하지 않고 즐겁게 목표를\n달성할 수 있도록 응원하고 있어요!").show(in: self)
    }
    func showNoGoalContentsWarning() {
        let sheet = RecordBottomSheetViewController(Image.flagMint, "지금은 씀씀이를 기록할 수 없어요", "나만의 소비 목표를 설정하고\n기록을 시작해보세요!").show(in: self)
    }
    // MARK: Move to other pages
    func moveToGenerateRecord() {
        let goal = viewModel.goals[selectedGoalIndex]
        let vc = GenerateRecordViewController(goal: goal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func moveToAllRecords(_ sender: GoalTapGesture) {
        let vc = AllRecordsViewController(self)
        vc.goalContent = sender.data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func moveToGenerateGoalDate() {
        let vc = GenerateGoalDateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: - CollectionView Delegate
extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier, for: indexPath)
                as? GoalTagCollectionViewCell else { fatalError() }
        
        let itemIdx = indexPath.row
        cell.title = viewModel.goals[itemIdx].name
        
        if itemIdx == self.selectedGoalIndex {cell.setSelectState()}
        else if viewModel.goals[itemIdx].isGoalEnd {cell.setInactivateState()} // 기한이 지난 목표일 때
        else {cell.setUnselectState()}
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        goalRelay.accept(indexPath.row)
        
        // 기간이 지난 목표
//        if isGoalDateEnd(goalContent[itemIdx]) || self.noSecondEmotionRecords.count != 0 {self.showNoSecondEmotionWarning()}
        
        // 목표에 저장된 씀씀이 조회
//        self.recordPage = 0
//        self.recordsOfGoal.removeAll()
//        getRecordsOfGoal(id: goalContent[itemIdx].id)
//        getNoSecondEmotionRecords(id: goalContent[itemIdx].id)
//
//        self.recordView.recordTableView.reloadData()
        
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setSelectState()
        }
        goalRelay.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setUnselectState()
        }
    }
    
    // 글자수에 따른 셀 너비 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = viewModel.goals.isEmpty ? GoalTagCollectionViewCell.emptyTitle : viewModel.goals[indexPath.row].name
        return GoalTagCollectionViewCell.estimatedSize(title: title)
    }
    
}
// MARK: - TableView delegate
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /* 무한 스크롤
            itemIdx = 3개 셀 제외하고 기록카드부터 시작
            size = 15개
            recordPage = 0부터 시작
         */
        let itemIdx = indexPath.row - 2
        let size = Const.requestPagingSize
        if (itemIdx % size == 0) && (itemIdx / size == recordPage ?? 0 - 1) {
            recordPage = (recordPage ?? 0) + 1
            if !viewModel.goals.isEmpty {
                self.viewModel.refreshData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.records.count
        if count == 0 {
            EmptyView(self.recordView.recordTableView).showEmptyView(Image.noting, "기록한 씀씀이가 없어요")
        } else {
            EmptyView(self.recordView.recordTableView).hideEmptyView()
        }
        return count + COUNT_OF_NOT_RECORD_CELL
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
            case 0:     return getGoalCategoryTableViewCell(indexPath: indexPath)
            case 1:
                // MARK: 목표가 존재하지 않을 때
                if viewModel.goals.isEmpty {return getNoGoalBannerTableViewCell(indexPath: indexPath)}
                // MARK: 기간이 지난 목표 셀
                else if viewModel.goals[selectedGoalIndex].isGoalEnd {return getFinishedGoalBannerTableViewCell(indexPath: indexPath)}
                else {return getGoalTableViewCell(indexPath: indexPath)}
                
            case 2:     return getNoSecondEmotionRecordsTableViewCell(indexPath: indexPath)
            default:    return getRecordsOfGoalTableViewCell(indexPath: indexPath)
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        if tag == 2 && !viewModel.goals.isEmpty {
            let vc = RecordEmotionViewController()
            vc.goalContent = viewModel.goals[self.selectedGoalIndex]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tag > 2 {
             cannotAddEmotionWarning()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getGoalTableViewCell(indexPath: IndexPath) -> GoalTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: GoalTableViewCell.self).then{
            $0.setUpData(viewModel.goals[self.selectedGoalIndex])
            // Alert Menu
            let deleteGoalGesture = GoalTapGesture(target: self, action: #selector(alertGoalMenuButtonDidTap(_:)))
            deleteGoalGesture.data = viewModel.goals[self.selectedGoalIndex]
            $0.menuButton.addGestureRecognizer(deleteGoalGesture)
        }
    }
    
    private func getNoGoalBannerTableViewCell(indexPath: IndexPath) -> GoalBannerTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: GoalBannerTableViewCell.self).then{
            $0.banner = .registerInRecord
            $0.actionButton.addTarget(self, action: #selector(addGoalButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func getFinishedGoalBannerTableViewCell(indexPath: IndexPath) -> GoalBannerTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: GoalBannerTableViewCell.self).then{
            $0.banner = .finish
            
            let finishGoalGesture = GoalTapGesture(target: self, action: #selector(finishGoalButtonDidTap(_:)))
            finishGoalGesture.data = viewModel.goals[self.selectedGoalIndex]
            $0.actionButton.addGestureRecognizer(finishGoalGesture)
        }
    }
    
    private func getGoalCategoryTableViewCell(indexPath: IndexPath) -> GoalCategoryTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: GoalCategoryTableViewCell.self).then{
            $0.selectionStyle = .none
            $0.goalCollectionView.delegate = self
            $0.goalCollectionView.dataSource = self
            $0.goalCollectionView.reloadData()
            
            // Add Goal
            $0.goalPlusButton.addTarget(self, action: #selector(addGoalButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func getRecordsOfGoalTableViewCell(indexPath: IndexPath) -> ConsumeReviewTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self).then{
            $0.delegate = self
            $0.bindingData(with: viewModel.records[dataIndexBy(indexPath)])
        }
    }
    
    private func getNoSecondEmotionRecordsTableViewCell(indexPath: IndexPath) -> GoEmotionBannerTableViewCell{
        recordView.recordTableView.dequeueReusableCell(for: indexPath, cellType: GoEmotionBannerTableViewCell.self).then{
            $0.bindingData(viewModel.noSecondEmotionRecords)
            $0.selectionStyle = .none
        }
    }
}
// MARK: - Record Cell delegate
extension RecordViewController: RecordCellDelegate{
    func presentReactionSheet(indexPath: IndexPath) {
        let data = recordsOfGoal[dataIndexBy(indexPath)].friendReactions
        FriendReactionSheetViewController(reactions: data).show(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {
        let recordIndex = dataIndexBy(indexPath)

        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default){ [self] _ in
            alert.dismiss(animated: true)
            let vc = ModifyRecordViewController(modifyViewModel: viewModel,
                                                index: recordIndex,
                                                goal: viewModel.goals[recordIndex])
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            ImageAlert.deleteRecord.generateAndShow(in: self).do{
                $0.completion = {
                    self.viewModel.deleteRecord(index: recordIndex)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
    }
}
// MARK: - Refresh Control
extension RecordViewController {
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .black
        
        self.recordView.recordTableView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.refreshData()
            refresh.endRefreshing()
        }
    }
}
////MARK: - API
//extension RecordViewController {
//    // MARK: 목표 리스트 조회 API
//    func requestGetGoals(){
//        // api 호출할 때마다 Goal 배열 초기화
//        self.goalContent.removeAll()
//        GoalService.shared.getUserGoals{ result in
//            defer{
//                self.isFirstLoad = false
//            }
//            switch result{
//            case .success(let data):
//                print("success goal:", data.content)
//                for x in data.content {
//                    if !x.isEnd {
//                        self.goalContent.append(x)
//                    }
//                }
//                // 목표에 맞는 기록들 조회
//                if !self.goalContent.isEmpty {
//                    // 기록 초기화 후 다시 호출
//                    self.recordPage = 0
//                    self.recordsOfGoal.removeAll()
//                    self.getRecordsOfGoal(id: self.goalContent[self.selectedGoalIndex].id)
//                }
//
//                if let cell = self.recordView.recordTableView.cellForRow(at: [0,0]) as? GoalCategoryTableViewCell {
//                    cell.goalCollectionView.reloadData()
//                    self.recordView.recordTableView.reloadData()
//                }
//                self.refreshControl.endRefreshing()
//                break
//            default:
//                print(result)
//                NetworkAlert.show(in: self){ [weak self] in
//                    self?.requestGetGoals()
//                }
//                break
//            }
//        }
//    }
//    // MARK: 목표 삭제 API
//    private func deleteGoal(id: Int){
//        GoalService.shared.deleteGoal(id: id) { result in
//            switch result{
//            case .success(let data):
//                if data.success {
//                    print("목표 삭제 성공")
//                    self.selectedGoalIndex = 0
//                    self.requestGetGoals()
//                    GoalObserver.shared.deleteGoal.onNext(Void())
//                }
//                break
//            default:
//                print(result)
//                break
//            }
//        }
//    }
//    // MARK: 목표에 해당하는 기록 조회 API
//    private func getRecordsOfGoal(id: Int) {
//        let pageModel = PageableModel(page: self.recordPage ?? 0)
//        RecordService.shared.getRecordsOfGoalAtRecordTab(id: id, pageable: pageModel) { result in
//            switch result{
//            case .success(let data):
////                print("LOG: 씀씀이 조회", data)
//                // Paging 때문에 append하는 방식으로 작업
//                for recordData in data.content {
//                    self.recordsOfGoal.append(recordData)
//                }
//                self.getNoSecondEmotionRecords(id: id)
//
//                break
//            default:
//                print(result)
//                NetworkAlert.show(in: self){ [weak self] in
//                    self?.getRecordsOfGoal(id: id)
//                }
//                break
//            }
//
//        }
//    }
//    // MARK: 기록 삭제 API
//    private func deleteRecord(id: Int) {
//        RecordService.shared.deleteRecord(id: id) { result in
//            print("기록 삭제 성공")
//            self.requestGetGoals()
//        }
//    }
//    // MARK: 일주일이 지났고, 두 번째 감정이 없는 기록 조회 API
//    private func getNoSecondEmotionRecords(id: Int) {
//        RecordService.shared.getNoSecondEmotionRecords(id: id) { result in
//            switch result{
//            case .success(let data):
////                print("LOG: 일주일이 지났고, 두 번째 감정이 없는 기록 조회", data)
//
//                self.noSecondEmotionRecords = data.content
//                self.recordView.recordTableView.reloadData()
//
//                break
//            default:
//                print(result)
//                break
//            }
//        }
//    }
//}
