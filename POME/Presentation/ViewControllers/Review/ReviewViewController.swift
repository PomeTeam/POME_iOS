//
//  ReviewViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation
import RxSwift
import RxCocoa

@frozen
enum EmotionTime: Int{
    case first = 100
    case second = 200
}

private extension IndexPath{
    var ofGoalData: Int{
        row
    }
    var ofRecordData: Int{
        row - 3
    }
}

struct Review{
    typealias EmotionFiltering = (first: Int?, second: Int?)
}

class ReviewViewController: BaseTabViewController{
    
    private let INFO_SECTION = 0
    private let COUNT_OF_NOT_RECORD_CELL = 3 //record 이외 UI 구성하는 cell 3개 존재
    
    private let mainView = ReviewView()
    private let viewModel = ReviewViewModel()
    private let firstEmotionFilterBottomSheet = EmotionFilterSheetViewController.generateFirstEmotionFilter()
    private let secondEmotionFilterBottomSheet = EmotionFilterSheetViewController.generateSecondEmotionFilter()
    
    //데이터 로드
    private var isLoading = false
    private var isRefreshing: Bool{
        guard let refreshControl = mainView.tableView.refreshControl else { return false }
        return refreshControl.isRefreshing
    }
    private var goalTableViewCell: GoalTagsTableViewCell?{
        mainView.tableView.cellForRow(at: [INFO_SECTION,0], cellType: GoalTagsTableViewCell.self)
    }
    
    //감정 필터링
    private typealias FilteringEmotion = (first: Int?, second: Int?)
    private let filterEmotion = BehaviorRelay<Review.EmotionFiltering>(value: (nil, nil))
    private var firstEmotion: Int?{
        filterEmotion.value.first
    }
    private var secondEmotion: Int?{
        filterEmotion.value.second
    }
    
    //목표
    private let goalRelay = BehaviorRelay<Int>(value: 0)
    private var selectedGoalIndex: Int{
        goalRelay.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshData()
    }
    
    override func layout(){
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize(){
        setTableViewDelegate()
        setTableViewRefresh()
    }
    
    private func setTableViewDelegate(){
        mainView.tableView.do{
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func setTableViewRefresh(){
        let refreshControl = UIRefreshControl().then{
            $0.backgroundColor = .white
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(refreshingData), for: .valueChanged)
        }
        mainView.tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshingData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.refreshData()
        }
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
        
        RecordObserver.shared.registerSecondEmotion
            .subscribe{ _ in
                self.goalRelay.accept(self.selectedGoalIndex)
            }.disposed(by: disposeBag)
        
        bindEmotionFiltering()
        
        viewModel.deleteRecordCompleted = {
            self.mainView.tableView.deleteRows(at: [[self.INFO_SECTION, $0 + self.COUNT_OF_NOT_RECORD_CELL]], with: .fade)
            self.showEmptyView()
        }
        
        viewModel.modifyRecordCompleted = { [self] in
            mainView.tableView.reloadRows(at: [[INFO_SECTION, $0 + COUNT_OF_NOT_RECORD_CELL]], with: .none)
        }
        
        viewModel.changeGoalSelect = { [weak self] in
            if let cell = self?.goalTableViewCell {
                self?.collectionView(cell.tagCollectionView, didSelectItemAt: [0,0])
            }
        }
        
        viewModel.reloadTableViewRelay
            .subscribe{ [weak self] _ in
                self?.stopRefreshingOrPaging()
                self?.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.transform(ReviewViewModel.Input(
            selectedGoalIndex: goalRelay.asObservable(),
            filteringEmotion: filterEmotion.asObservable())
        )
    }
    
    private func stopRefreshingOrPaging(){
        isLoading = false
        if isRefreshing {
            mainView.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func reloadData(){
        mainView.tableView.reloadData()
        goalTableViewCell?.tagCollectionView.reloadData()
        showEmptyView()
    }
    
    private func showEmptyView(){
        viewModel.records.isEmpty || viewModel.goals.isEmpty ? mainView.emptyViewWillShow() : mainView.emptyViewWillHide()
    }
    
    private func bindEmotionFiltering(){
        
        firstEmotionFilterBottomSheet.selectedEmotion = { [weak self] in
            self?.filterEmotion.accept(($0, self?.secondEmotion))
        }
        secondEmotionFilterBottomSheet.selectedEmotion = { [weak self] in
            self?.filterEmotion.accept((self?.firstEmotion, $0))
        }
        
        var filteringCell: ReviewFilterTableViewCell?{
            mainView.tableView.cellForRow(at: [INFO_SECTION,2], cellType: ReviewFilterTableViewCell.self)
        }
        filterEmotion
            .subscribe{
                filteringCell?.changeEmotionSelectState(firstEmotionId: $0.first, secondEmotionId: $0.second)
            }.disposed(by: disposeBag)
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.goals.isEmpty ? 1 : viewModel.goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(for: indexPath, cellType: GoalTagCollectionViewCell.self).then{
            $0.title = getGoalCellTitle(index: indexPath.row)
            selectedGoalIndex == indexPath.row ? $0.setSelectState() : $0.setUnselectState(with: isGoalEnd(index: indexPath.row))
        }
    }
    
    private func getGoalCellTitle(index: Int) -> String{
        viewModel.goals.isEmpty ? GoalTagCollectionViewCell.emptyTitle : viewModel.goals[index].name
    }
    private func isGoalEnd(index: Int) -> Bool{
        viewModel.goals[index].isGoalEnd
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = getGoalCellTitle(index: indexPath.row)
        return GoalTagCollectionViewCell.estimatedSize(title: title)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setSelectState()
        }
        goalRelay.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setUnselectState(with: isGoalEnd(index: indexPath.row))
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == INFO_SECTION {
            return viewModel.records.count + COUNT_OF_NOT_RECORD_CELL
        } else if section == 2 && isLoading && viewModel.hasNextPage {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != INFO_SECTION {
            return getLoadingTableViewCell(indexPath: indexPath)
        }
        
        switch indexPath.row {
        case 0:     return getGoalTagsTableViewCell(indexPath: indexPath)
        case 1:     return getGoalInfoSectionTableViewCell(indexPath: indexPath)
        case 2:     return getFilterTableViewCell(indexPath: indexPath)
        default:    return getRecordTableViewCell(indexPath: indexPath)
        }
    }
    
    private func getLoadingTableViewCell(indexPath: IndexPath) -> LoadingTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self).then{
            $0.startLoading()
        }
    }
    
    private func getGoalTagsTableViewCell(indexPath: IndexPath) -> GoalTagsTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: GoalTagsTableViewCell.self).then{
            $0.tagCollectionView.delegate = self
            $0.tagCollectionView.dataSource = self
        }
    }
    
    private func getGoalInfoSectionTableViewCell(indexPath: IndexPath) -> BaseTableViewCell {
        if viewModel.goals.isEmpty {
            return getGoalEmptyBannerTableViewCell(indexPath: indexPath)
        } else {
            return getGoalDetailTableViewCell(indexPath: indexPath)
        }
    }
    
    private func getGoalEmptyBannerTableViewCell(indexPath: IndexPath) -> BaseTableViewCell {
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: GoalBannerTableViewCell.self).then{
            $0.banner = .registerInReview
            $0.actionButton.addTarget(self, action: #selector(willMoveGoalRegisterViewController), for: .touchUpInside)
        }
    }
    
    @objc private func willMoveGoalRegisterViewController(){
        navigationController?.pushViewController(GenerateGoalDateViewController(), animated: true)
    }
    
    private func getGoalDetailTableViewCell(indexPath: IndexPath) -> GoalDetailTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: GoalDetailTableViewCell.self).then{
            viewModel.goals.isEmpty ? $0.bindingEmptyData() : $0.bindingData(goal: viewModel.goals[selectedGoalIndex])
        }
    }
    
    private func getFilterTableViewCell(indexPath: IndexPath) -> ReviewFilterTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: ReviewFilterTableViewCell.self).then{
            $0.delegate = self
        }
    }
    
    private func getRecordTableViewCell(indexPath: IndexPath) -> ConsumeReviewTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self).then{
            $0.delegate = self
            $0.bindingData(with: viewModel.records[indexPath.ofRecordData])
        }
    }
}

extension ReviewViewController: FilterDelegate{
    
    func willShowFilterBottomSheet(time: EmotionTime) {
        let filterSheet = {
            switch time {
            case .first:    return firstEmotionFilterBottomSheet
            case .second:   return secondEmotionFilterBottomSheet
            }
        }()
        filterSheet.show(in: self)
    }
    
    func initializeFilteringCondition() {
        filterEmotion.accept((nil, nil))
    }
}

extension ReviewViewController: RecordCellDelegate{
    
    func presentReactionSheet(indexPath: IndexPath) {
        let data = viewModel.records[indexPath.ofRecordData].friendReactions
        FriendReactionSheetViewController(reactions: data).show(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then{
            $0.addAction(generateModifyAction($0, indexPath: indexPath))
            $0.addAction(generateDeleteAction($0, indexPath: indexPath))
            $0.addAction(generateCancelAction())
        }
        present(alert, animated: true)
    }
    
    private func generateModifyAction(_ alert: UIAlertController, indexPath: IndexPath) -> UIAlertAction{
        return UIAlertAction(title: "수정하기", style: .default){ [self] _ in
            alert.dismiss(animated: true)
            let vc = ModifyRecordViewController(modifyViewModel: viewModel,
                                                index: indexPath.ofRecordData,
                                                goal: viewModel.goals[selectedGoalIndex])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func generateDeleteAction(_ alert: UIAlertController, indexPath: IndexPath) -> UIAlertAction{
        return UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            ImageAlert.deleteRecord.generateAndShow(in: self).do{
                $0.completion = {
                    self.viewModel.deleteRecord(index: indexPath.ofRecordData)
                }
            }
        }
    }
    
    private func generateCancelAction() -> UIAlertAction{
        return UIAlertAction(title: "취소", style: .cancel, handler: nil)
    }
}

extension ReviewViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if !isLoading && viewModel.hasNextPage {
                beginPaging()
            }
        }
    }
    
    private func beginPaging(){
        isLoading = true
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.requestNextPage()
        }
    }
}
