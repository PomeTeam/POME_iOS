//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class ReviewViewController: BaseTabViewController, ControlIndexPath {
    
    //MARK: - Properties
    
    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 3
    }
    
    let filterInitialState = -1
    var filterController: (Int, Int)!
    var currentEmotionSelectCardIndex: Int?
    var currentGoal: Int = 0{
        didSet{
            requestGetRecords()
        }
    }
    var goals = [GoalResponseModel](){
        didSet{
            if let cell = self.mainView.tableView.cellForRow(at: [0,0]) as? GoalTagsTableViewCell{
                cell.tagCollectionView.reloadData()
                mainView.tableView.reloadData()
            }
        }
    }
    var filteredRecords = [RecordResponseModel](){
        didSet{
            isTableViewEmpty()
            mainView.tableView.reloadData()
        }
    }
    var records = [RecordResponseModel](){
        didSet{
            filteredRecords = records
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
        
        filterController = (filterInitialState, filterInitialState)
    }
    
    override func topBtnDidClicked() {
        let vc = NotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Method
    
    private func isTableViewEmpty(){
        filteredRecords.isEmpty ? mainView.emptyViewWillShow() : mainView.emptyViewWillHide()
    }
    
    @objc func filterButtonDidClicked(_ sender: UIButton){
        
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
            self.filterRecordsByEmotion()
        }
        
        _ = sheet.loadAndShowBottomSheet(in: self)
    }
    
    @objc func filterInitializeButtonDidClicked(){
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        cell.firstEmotionFilter.setFilterDefaultState()
        cell.secondEmotionFilter.setFilterDefaultState()
        filterController = (filterInitialState, filterInitialState)
        filteredRecords = records
    }
    
    private func filterRecordsByEmotion(){
        
        var filter = records
        
        if(filterController.0 != filterInitialState){
            filter = filter.filter({
                $0.emotionResponse.firstEmotion == filterController.0
            })
        }
        if(filterController.1 != filterInitialState){
            filter = filter.filter({
                $0.emotionResponse.secondEmotion == filterController.1
            })
        }
        
        filteredRecords = filter
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
        RecordService.shared.getRecordsOfGoal(id: goalId, pageable: PageableModel(page: 0)){ response in
            switch response {
            case .success(let data):
                print("LOG: success requestGetRecords", data)
                self.records = data.content
                break
            default:
                print("LOG: fail requestGetRecords", response)
                break
            }
        }
    }
    
    func requestGenerateFriendCardEmotion(reactionIndex: Int) {
        guard let cellIndex = self.currentEmotionSelectCardIndex,
                let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: filteredRecords[cellIndex].id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success:
                self.filteredRecords[cellIndex].emotionResponse.myEmotion = reactionIndex
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                break
            default:
                print(result)
                break
            }
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
    
        currentGoal == indexPath.row ? cell.setSelectState() : cell.setUnselectState()
        
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
            cell.setUnselectState()
        }
        currentGoal = indexPath.row
        cell.setSelectState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalTagCollectionViewCell else { return }
        cell.setUnselectState()
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecords.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GoalTagsTableViewCell.self)
            cell.tagCollectionView.delegate = self
            cell.tagCollectionView.dataSource = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GoalDetailTableViewCell.self)
            goals.isEmpty ? cell.bindingEmptyData() : cell.bindingData(goal: goals[currentGoal])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReviewFilterTableViewCell.self)
            cell.firstEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
            cell.secondEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
            cell.reloadingButton.addTarget(self, action: #selector(filterInitializeButtonDidClicked), for: .touchUpInside)
            return cell
        default:
            //TODO: 기록 데이터 바인딩
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self)
            
            let cardIndex = dataIndexBy(indexPath)
            let record = filteredRecords[cardIndex]
            
            cell.delegate = self
            cell.mainView.dataBinding(with: record)
        
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < 3){
            return
        }
        let dataIndex = dataIndexBy(indexPath)
        let vc = ReviewDetailViewController(record: filteredRecords[dataIndex])
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
        let data = filteredRecords[dataIndexBy(indexPath)].friendReactions
        _ = FriendReactionSheetViewController(reactions: data).loadAndShowBottomSheet(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {

        let recordIndex = dataIndexBy(indexPath)
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let hideAction = UIAlertAction(title: "수정하기", style: .default){ _ in
            alert.dismiss(animated: true)
            let vc = RecordModifyContentViewController(goal: self.goals[self.currentGoal],
                                                       record: self.records[recordIndex])
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let declarationAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(hideAction)
        alert.addAction(declarationAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
    }
}
