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
    
    private var isLoading = false
    
    private let INFO_SECTION = 1
    private let COUNT_OF_NOT_RECORD_CELL = 3 //record 이외 UI 구성하는 cell 3개 존재
    private let mainView = ReviewView()
    
    private lazy var viewModel = ReviewViewModel(regardlessOfRecordCount: COUNT_OF_NOT_RECORD_CELL)
    private lazy var firstEmotionFilterBottomSheet = EmotionFilterSheetViewController.generateFirstEmotionFilter()
    private lazy var secondEmotionFilterBottomSheet = EmotionFilterSheetViewController.generateSecondEmotionFilter()
    
    //감정 필터링 프로퍼티
    private typealias FilteringEmotion = (first: Int?, second: Int?)
    private let filterEmotion = BehaviorRelay<Review.EmotionFiltering>(value: (nil, nil))
    private var firstEmotion: Int?{
        filterEmotion.value.first
    }
    private var secondEmotion: Int?{
        filterEmotion.value.second
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
    }
    private func setTableViewDelegate(){
        mainView.tableView.do{
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
        }
    }

    override func bind() {
        
        bindEmotionFiltering()
        
        let output = viewModel.transform(ReviewViewModel.Input(filteringEmotion: filterEmotion.asObservable()))
        
        output.showEmptyView
            .drive(onNext: { [weak self] willShow in
                willShow ? self?.mainView.emptyViewWillShow() : self?.mainView.emptyViewWillHide()
            }).disposed(by: disposeBag)
        
        var goalTableViewCell: GoalTagsTableViewCell?{
            mainView.tableView.cellForRow(at: [INFO_SECTION,0], cellType: GoalTagsTableViewCell.self)
        }
        
        output.reloadTableView
            .drive(onNext: { [weak self] in
                self?.isLoading = false
                goalTableViewCell?.tagCollectionView.reloadData()
                self?.mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.deleteRecord
            .drive(onNext: { indexPath in
                self.mainView.tableView.deleteRows(at: [indexPath], with: .fade)
            }).disposed(by: disposeBag)
        
        output.modifyRecord
            .drive(onNext: { indexPath in
                self.mainView.tableView.reloadRows(at: [indexPath], with: .none)
            }).disposed(by: disposeBag)
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
        viewModel.isGoalEmpty ? 1 : viewModel.goalsCount
    }
    
    private func getGoalCellTitle(index: Int) -> String{
        viewModel.isGoalEmpty ? GoalTagCollectionViewCell.emptyTitle : viewModel.getGoal(at: index).name
    }
    
    private func isGoalEnd(index: Int) -> Bool{
        viewModel.getGoal(at: index).isGoalEnd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(for: indexPath, cellType: GoalTagCollectionViewCell.self).then{
            $0.title = getGoalCellTitle(index: indexPath.row)
            viewModel.selectedGoalIndex == indexPath.row ? $0.setSelectState() : $0.setUnselectState(with: isGoalEnd(index: indexPath.row))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = getGoalCellTitle(index: indexPath.row)
        return GoalTagCollectionViewCell.estimatedSize(title: title)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setSelectState()
        }
        viewModel.selectGoal(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath, cellType: GoalTagCollectionViewCell.self)?.do{
            $0.setUnselectState(with: isGoalEnd(index: indexPath.row))
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == INFO_SECTION {
            return viewModel.recordsCount + COUNT_OF_NOT_RECORD_CELL
        }else if (section == 0 && isLoading) || (section == 2 && isLoading && viewModel.hasNextPage){
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != INFO_SECTION {
            return getLoadingTableViewCell(indexPath: indexPath)
        }
        
        switch indexPath.row {
        case 0:     return getGoalTagsTableViewCell(indexPath: indexPath)
        case 1:     return getGoalDetailTableViewCell(indexPath: indexPath)
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
    
    private func getGoalDetailTableViewCell(indexPath: IndexPath) -> GoalDetailTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: GoalDetailTableViewCell.self).then{
            viewModel.isGoalEmpty ? $0.bindingEmptyData() : $0.bindingData(goal: viewModel.selectedGoal)
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
            $0.bindingData(with: viewModel.getRecord(at: indexPath.row))
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
        let data = viewModel.getRecord(at: indexPath.row).friendReactions
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
        return UIAlertAction(title: "수정하기", style: .default){ _ in
            alert.dismiss(animated: true)
            let vc = ModifyRecordViewController(modifyViewModel: self.viewModel, indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func generateDeleteAction(_ alert: UIAlertController, indexPath: IndexPath) -> UIAlertAction{
        return UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            ImageAlert.deleteRecord.generateAndShow(in: self).do{
                $0.completion = {
                    self.viewModel.deleteRecord(at: indexPath)
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
        checkPaigingConditionAndStartPaging(offset: offsetY, scrollView: scrollView)
        checkRefreshingConditionAndStartRefreshing(offset: offsetY)
    }
    
    private func checkPaigingConditionAndStartPaging(offset: CGFloat, scrollView: UIScrollView){
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offset > (contentHeight - height) {
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
    
    private func checkRefreshingConditionAndStartRefreshing(offset: CGFloat){
        if offset < Offset.REFRESH_DATA && !isLoading {
            beginRefreshData()
        }
    }
    
    private func beginRefreshData(){
        isLoading = true
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.refreshData()
        }
    }
}
