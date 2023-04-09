//
//  ReviewTestViewController.swift
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

class ReviewTestViewController: BaseTabViewController{
    
    private var isPaging = false
    
    private let COUNT_OF_NOT_RECORD_CELL = 3 //record 이외 UI 구성하는 cell 3개 존재
    private let mainView = ReviewView()
    
    private lazy var viewModel = ReviewViewModel(regardlessOfRecordCount: COUNT_OF_NOT_RECORD_CELL)
    private lazy var firstEmotionFilterBottomSheet = EmotionFilterTestSheetViewController.generateFirstEmotionFilter(viewModel: viewModel)
    private lazy var secondEmotionFilterBottomSheet = EmotionFilterTestSheetViewController.generateSecondEmotionFilter(viewModel: viewModel)
    
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
        
        let output = viewModel.transform(ReviewViewModel.Input())
        
        output.showEmptyView
            .drive(onNext: { [weak self] willShow in
                willShow ? self?.mainView.emptyViewWillShow() : self?.mainView.emptyViewWillHide()
            }).disposed(by: disposeBag)
        
        var goalTableViewCell: GoalTagsTableViewCell?{
            mainView.tableView.cellForRow(at: [0,0], cellType: GoalTagsTableViewCell.self)
        }
        
        output.reloadTableView
            .drive(onNext: { [weak self] in
                self?.isPaging = false
                goalTableViewCell?.tagCollectionView.reloadData()
                self?.mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        
        var filteringCell: ReviewFilterTableViewCell?{
            mainView.tableView.cellForRow(at: [0,2], cellType: ReviewFilterTableViewCell.self)
        }
        
        output.firstEmotionState
            .drive(onNext: {
                filteringCell?.firstEmotionFilter.setFilterSelectState(emotion: $0)
            }).disposed(by: disposeBag)
        
        output.secondEmotionState
            .drive(onNext: {
                filteringCell?.secondEmotionFilter.setFilterSelectState(emotion: $0)
            }).disposed(by: disposeBag)
        
        output.initializeEmotionFilter
            .drive(onNext: {
                filteringCell?.do{
                    $0.firstEmotionFilter.setFilterDefaultState()
                    $0.secondEmotionFilter.setFilterDefaultState()
                }
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
}

extension ReviewTestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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

extension ReviewTestViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return viewModel.recordsCount + COUNT_OF_NOT_RECORD_CELL
        }else if(section == 1 && isPaging && viewModel.hasNextPage()){
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1){
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

extension ReviewTestViewController: FilterDelegate{
    
    func willShowFilterBottomSheet(time: EmotionTime) {
        let filterSheet = {
            switch time {
            case .first:    return firstEmotionFilterBottomSheet
            case .second:   return secondEmotionFilterBottomSheet
            }
        }()
        filterSheet.loadAndShowBottomSheet(in: self)
    }
    
    func initializeFilteringCondition() {
        viewModel.initializeFilterCondtion()
    }
}

extension ReviewTestViewController: RecordCellDelegate{
    
    func presentReactionSheet(indexPath: IndexPath) {
        let data = viewModel.getRecord(at: indexPath.row).friendReactions
        FriendReactionSheetTestViewController(reactions: data).loadAndShowBottomSheet(in: self)
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

extension ReviewTestViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        if offsetY > (contentHeight - height) {
            if isPaging == false && viewModel.hasNextPage() {
                beginPaging()
            }
        }
    }

    private func beginPaging(){
        isPaging = true
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.requestNextPage()
        }
    }
}
