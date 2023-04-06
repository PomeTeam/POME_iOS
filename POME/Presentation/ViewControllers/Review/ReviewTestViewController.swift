//
//  ReviewTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation

@frozen
enum EmotionTime: Int{
    case first = 100
    case second = 200
}

class ReviewTestViewController: BaseTabViewController{
    
    private var isPaging: Bool = false
    
    private let COUNT_OF_NOT_RECORD_CELL = 3 //record 이외 UI 구성하는 cell 3개 존재
    private let mainView = ReviewView()
    private lazy var viewModel = ReviewViewModel(regardlessOfRecordCount: COUNT_OF_NOT_RECORD_CELL)
    private lazy var firstEmotionFilterBottomSheet = EmotionFilterTestSheetViewController.generateFirstEmotionFilter(viewModel: viewModel)
    private lazy var secondEmotionFilterBottomSheet = EmotionFilterTestSheetViewController.generateSecondEmotionFilter(viewModel: viewModel)
    
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
    
    override func bind() {
        
        let output = viewModel.transform(ReviewViewModel.Input())
        
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
    }
    
    private func setTableViewDelegate(){
        mainView.tableView.do{
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
        }
    }
}

extension ReviewTestViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.goalsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(for: indexPath, cellType: GoalTagCollectionViewCell.self)
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
        
    }
}

extension ReviewTestViewController{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.height
//
//        if offsetY > (contentHeight - height) {
//            if isPaging == false && viewModel.hasNextPage() {
//                beginPaging()
//            }
//        }
//    }
//
//    private func beginPaging(){
//
//        isPaging = true
//        viewModel.requestNextPage()
//
//        DispatchQueue.main.async { [self] in
//            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////            self.requestGetRecords()
//        }
//    }
}
