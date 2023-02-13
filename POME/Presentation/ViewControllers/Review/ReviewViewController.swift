//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class ReviewViewController: BaseTabViewController, ControlIndexPath, Pageable {
    
    //MARK: - Properties
    
    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 3
    }
    
    var page = 0{
        didSet{
            if(page == 0){
                hasNextPage = false
            }
        }
    }
    var isPaging: Bool = false
    var hasNextPage: Bool = false

    var filterController: (Int?, Int?) = (nil, nil){
        didSet{
            page = 0
            requestGetRecords()
        }
    }
    var currentEmotionSelectCardIndex: Int?
    var currentGoal: Int = 0{
        didSet{
            page = 0
            requestGetRecords()
        }
    }
    var goals = [GoalResponseModel](){
        didSet{
            if let cell = self.mainView.tableView.cellForRow(at: [0,0]) as? GoalTagsTableViewCell{
                cell.tagCollectionView.reloadData()
            }
        }
    }
    
    private var willDelete = false
    private var records = [RecordResponseModel](){
        didSet{
            if(willDelete){
                return
            }
            isPaging = false
            isTableViewEmpty()
            mainView.tableView.reloadData()
        }
    }
    
    let mainView = ReviewView()
    var emoijiFloatingView: EmojiFloatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetGoals()
    }
    
    //MARK: - Override
    
    override func layout(){
        super.layout()
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize(){
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func topBtnDidClicked() {
        let vc = NotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Method
    
    private func isTableViewEmpty(){
        records.isEmpty ? mainView.emptyViewWillShow() : mainView.emptyViewWillHide()
    }
    
    @objc func filterButtonDidClicked(_ sender: UIButton){
        
        page = 0
        
        let sheet: EmotionFilterSheetViewController!
        var emotionTime: EmotionTime!
        
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        //TODO: Tag 활용하는 방식으로 변경하기
        if(sender == cell.firstEmotionFilter.filterButton){
            emotionTime = .first
            sheet = EmotionFilterSheetViewController.generateFirstEmotionFilterSheet()
        }else{
            emotionTime = .second
            sheet = EmotionFilterSheetViewController.generateSecondEmotionFilterSheet()
        }
        
        sheet.completion = { emotion in
            
            switch emotionTime{
            case .first:
                self.filterController.0 = emotion
            case .second:
                self.filterController.1 = emotion
            default:
                return
            }
            
            guard let filterView = sender.superview as? ReviewFilterTableViewCell.EmotionFilterView,
                    let emotion = EmotionTag(rawValue: emotion) else { return }
            
            filterView.setFilterSelectState(emotion: emotion)
        }
        
        _ = sheet.loadAndShowBottomSheet(in: self)
    }
    
    @objc func filterInitializeButtonDidClicked(){
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        cell.firstEmotionFilter.setFilterDefaultState()
        cell.secondEmotionFilter.setFilterDefaultState()
        filterController = (nil, nil)
    }
}

extension ReviewViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage {
                beginPaging()
            }
        }
    }
    
    func beginPaging(){
        
        isPaging = true
        page = page + 1
        
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.requestGetRecords()
        }
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        goals.count == 0 ? 1 : goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GoalTagCollectionViewCell.self)

        cell.goalCategoryLabel.text = goals.isEmpty ? "···" : goals[indexPath.row].goalNameBinding
    
        currentGoal == indexPath.row ? cell.setSelectState() : cell.setUnselectState(with: goals[indexPath.row].isGoalEnd)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let testLabel = UILabel().then{
            $0.text = goals.isEmpty ? "···" : goals[indexPath.row].goalNameBinding
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        }
        
        let width = testLabel.intrinsicContentSize.width + 12 * 2
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalTagCollectionViewCell else { return }
        if(currentGoal == 0 && indexPath.row != 0){
            guard let cell = collectionView.cellForItem(at: [0,0]) as? GoalTagCollectionViewCell else { return }
            cell.setUnselectState(with: goals[indexPath.row].isGoalEnd)
        }
        currentGoal = indexPath.row
        cell.setSelectState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalTagCollectionViewCell else { return }
        cell.setUnselectState(with: goals[indexPath.row].isGoalEnd)
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return records.count + 3
        }else if(section == 1 && isPaging && hasNextPage){
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self).then{
                $0.startLoading()
            }
            return cell
        }
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GoalTagsTableViewCell.self).then{
                $0.tagCollectionView.delegate = self
                $0.tagCollectionView.dataSource = self
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GoalDetailTableViewCell.self)
            goals.isEmpty ? cell.bindingEmptyData() : cell.bindingData(goal: goals[currentGoal])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReviewFilterTableViewCell.self).then{
                $0.firstEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
                $0.secondEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
                $0.reloadingButton.addTarget(self, action: #selector(filterInitializeButtonDidClicked), for: .touchUpInside)
            }
            return cell
        default:
            let cardIndex = dataIndexBy(indexPath)
            let record = records[cardIndex]
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self).then{
                $0.delegate = self
                $0.mainView.dataBinding(with: record)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < 3){
            return
        }
        let dataIndex = dataIndexBy(indexPath)
        let vc = ReviewDetailViewController(recordIndex: dataIndex, goal: goals[currentGoal], record: records[dataIndex]).then{
            $0.delegate = self
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReviewViewController: RecordCellWithEmojiDelegate{
    
    func presentEmojiFloatingView(indexPath: IndexPath) {

        self.currentEmotionSelectCardIndex = dataIndexBy(indexPath)
        
        emoijiFloatingView = EmojiFloatingView().then{
            $0.delegate = self
            $0.completion = {
                print("LOG: emoijiFloatingView completion closure called")
                self.currentEmotionSelectCardIndex = nil
                self.emoijiFloatingView = nil
            }
        }

        guard let cell = mainView.tableView.cellForRow(at: indexPath) as? ConsumeReviewTableViewCell else { return }
        emoijiFloatingView.show(in: self, standard: cell)
    }
    
    func presentReactionSheet(indexPath: IndexPath) {
        let data = records[dataIndexBy(indexPath)].friendReactions
        _ = FriendReactionSheetViewController(reactions: data).loadAndShowBottomSheet(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {

        let recordIndex = dataIndexBy(indexPath)
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default){ _ in
            alert.dismiss(animated: true)
            let vc = RecordModifyContentViewController(goal: self.goals[self.currentGoal],
                                                       record: self.records[recordIndex])
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            let alert = ImageAlert.deleteRecord.generateAndShow(in: self)
            alert.completion = {
                self.requestDeleteRecord(indexPath: indexPath)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
    }
}

//MARK: - API
extension ReviewViewController{
    
    private func requestGetGoals(){
        GoalService.shared.getUserGoals{ [self] response in
            switch response{
            case .success(let data):
                print("LOG: success requestGetGoals", data)
                goals = data.content
                requestGetRecords()
                break
            default:
                print("LOG: fail requestGetGoals", response)
                break
            }
        }
    }

    private func requestGetRecords(){
        let goalId = goals[currentGoal].id
        let loadingViewAnimate = page == 0 ? true : false
        RecordService.shared.getRecordsOfGoalAtReviewTab(id: goalId,
                                                         firstEmotion: filterController.0,
                                                         secondEmotion: filterController.1,
                                                         pageable: PageableModel(page: page),
                                                         animate: loadingViewAnimate){ response in
            switch response {
            case .success(let data):
                print("LOG: success requestGetRecords", data)
                self.processResponseGetRecords(data: data)
                return
            default:
                print("LOG: fail requestGetRecords", response)
                break
            }
        }
    }
    
    private func processResponseGetRecords(data: PageableResponseModel<RecordResponseModel>){
        
        hasNextPage = !data.last
        
        if(page == 0){
            records = data.content
        }else{
            records.append(contentsOf: data.content)
        }
        
        if(data.empty){
            recordRequestIsEmpty()
        }
    }
    
    func recordRequestIsEmpty() {
        isPaging = false
        mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func requestGenerateFriendCardEmotion(reactionIndex: Int) {
        guard let cellIndex = self.currentEmotionSelectCardIndex,
                let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: records[cellIndex].id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success(let data):
                print("LOG: SUCCESS requestGenerateFriendCardEmotion", data)
                self.records[cellIndex] = data
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                break
            default:
                print(result)
                break
            }
        }
    }
    
    private func requestDeleteRecord(indexPath: IndexPath){
        let index = dataIndexBy(indexPath)
        let record = records[index]
        RecordService.shared.deleteRecord(id: record.id){ response in
            switch response {
            case .success:
                self.processResponseDeleteRecord(indexPath: indexPath)
                print("LOG: success requestDeleteRecord")
                break
            default:
                print("LOG: fail requestGetRecords", response)
                break
            }
        }
    }
    private func processResponseDeleteRecord(indexPath: IndexPath){
        self.willDelete = true
        let recordIndex = dataIndexBy(indexPath)
        self.records.remove(at: recordIndex)
        self.mainView.tableView.deleteRows(at: [indexPath], with: .fade)
        self.willDelete = false
    }
}

extension ReviewViewController: ReviewDetailEditable{
    
    func processResponseModifyRecordInDetail(index: Int, record: RecordResponseModel){
        records[index] = record
    }
    
    func processResponseDeleteRecordInDetail(index: Int){
        records.remove(at: index)
    }
}
