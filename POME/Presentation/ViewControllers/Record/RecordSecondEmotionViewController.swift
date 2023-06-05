//
//  RecordEmotionViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit
import RxSwift
import RxCocoa


class RecordSecondEmotionViewController: BaseViewController {
    var recordEmotionView = RecordEmotionView()
    let viewModel = RecordSecondEmotionViewModel()
    
    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 1
    }
    var goalContent = GoalResponseModel(endDate: "", id: 0, isEnd: true, isPublic: true, name: "", nickname: "", oneLineMind: "", price: 0, startDate: "", usePrice: 0)
    private let goalRelay = PublishRelay<GoalResponseModel>()
    
    private let INFO_SECTION = 0
    private let COUNT_OF_NOT_RECORD_CELL = 1 //record 이외 UI 구성하는 cell 1개 존재

    
    // Cell Height
    var expendingCellContent = ExpandingTableViewCellContent()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalRelay.accept(goalContent)
        viewModel.refreshData()
    }
    
    override func style() {
        super.style()
        
        recordEmotionView.recordEmotionTableView.delegate = self
        recordEmotionView.recordEmotionTableView.dataSource = self
        EmptyView(recordEmotionView.recordEmotionTableView).showEmptyView(Image.noting, "돌아볼 씀씀이가 없어요")
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(recordEmotionView)
        recordEmotionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
    }
    
    override func bind() {
        RecordObserver.shared.deleteRecord
            .subscribe{ [weak self] _ in
                self?.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        RecordObserver.shared.registerSecondEmotion
            .subscribe{ _ in
                self.viewModel.refreshData()
            }.disposed(by: disposeBag)
        
        viewModel.deleteRecordSubject
            .subscribe{
                self.recordEmotionView.recordEmotionTableView.deleteRows(at: [[self.INFO_SECTION, $0 + self.COUNT_OF_NOT_RECORD_CELL]], with: .fade)
                self.showEmptyView()
            }.disposed(by: disposeBag)
        
        viewModel.modifyRecordSubject
            .subscribe{
                self.recordEmotionView.recordEmotionTableView.reloadRows(at: [[self.INFO_SECTION, $0 + self.COUNT_OF_NOT_RECORD_CELL]], with: .none)
            }.disposed(by: disposeBag)
        
        viewModel.reloadTableView
            .subscribe{ [weak self] _ in
                self?.reloadData()
            }.disposed(by: disposeBag)
        
        
        viewModel.transform(RecordSecondEmotionViewModel.Input(goal: goalRelay.asObservable()))
        
    }
    
    private func reloadData(){
        recordEmotionView.recordEmotionTableView.reloadData()
        showEmptyView()
    }
    
    private func showEmptyView(){
        viewModel.records.isEmpty
        ? EmptyView(recordEmotionView.recordEmotionTableView).showEmptyView(Image.noting, "돌아볼 씀씀이가 없어요")
        : EmptyView(recordEmotionView.recordEmotionTableView).hideEmptyView()
    }
    
//    // MARK: 더보기 버튼 - Dynamic Cell Height Method
//    @objc func viewMoreButtonDidTap(_ sender: IndexPathTapGesture) {
//        let content = expendingCellContent
//        content.expanded = !content.expanded
//        self.recordEmotionView.recordEmotionTableView.reloadRows(at: [sender.data], with: .automatic)
//    }
}
// MARK: - TableView delegate
extension RecordSecondEmotionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return COUNT_OF_NOT_RECORD_CELL + viewModel.records.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:     return getGoalTableViewCell(indexPath: indexPath)
        default:    return getRecordTableViewCell(indexPath: indexPath)
            
//            // 더보기 버튼 클릭 Gesture
//            let viewMoreGesture = IndexPathTapGesture(target: self, action: #selector(viewMoreButtonDidTap(_:)))
//            viewMoreGesture.data = indexPath
//            cell.viewMoreButton.addGestureRecognizer(viewMoreGesture)
//            // Cell Height Set
//            cell.settingHeight(isClicked: expendingCellContent)
//
//            cell.selectionStyle = .none
//            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        tag > 0 ? moveToSelectSecondEmotion(indexPath: indexPath) : tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getGoalTableViewCell(indexPath: IndexPath) -> RecordEmotionTableViewCell{
        recordEmotionView.recordEmotionTableView.dequeueReusableCell(for: indexPath, cellType: RecordEmotionTableViewCell.self).then{
            $0.setUpData(viewModel.goal, viewModel.records.count)
            $0.selectionStyle = .none
        }
    }
    
    private func getRecordTableViewCell(indexPath: IndexPath) -> ConsumeReviewTableViewCell{
        recordEmotionView.recordEmotionTableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self).then{
            $0.delegate = self
            $0.bindingData(with: viewModel.records[dataIndexBy(indexPath)])
        }
    }
    
    private func moveToSelectSecondEmotion(indexPath: IndexPath) {
        let vc = SelectEmotionViewController(type: .Second, recordId: viewModel.records[dataIndexBy(indexPath)].id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Record Cell delegate
extension RecordSecondEmotionViewController: RecordCellDelegate{
    func presentReactionSheet(indexPath: IndexPath) {
        let data = viewModel.records[dataIndexBy(indexPath)].friendReactions
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
        let recordIndex = dataIndexBy(indexPath)
        
        return UIAlertAction(title: "수정하기", style: .default){ [self] _ in
            alert.dismiss(animated: true)
            let vc = ModifyRecordViewController(goal: goalContent,
                                                record: viewModel.records[recordIndex])
            vc.completion = {
                self.viewModel.records[recordIndex] = $0
                self.recordEmotionView.recordEmotionTableView.reloadRows(at: [indexPath], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func generateDeleteAction(_ alert: UIAlertController, indexPath: IndexPath) -> UIAlertAction{
        let recordIndex = dataIndexBy(indexPath)
        
        return UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            ImageAlert.deleteRecord.generateAndShow(in: self).do{
                $0.completion = {
                    self.viewModel.deleteRecord(index: recordIndex)
                }
            }
        }
    }
    
    private func generateCancelAction() -> UIAlertAction{
        return UIAlertAction(title: "취소", style: .cancel, handler: nil)
    }
}
