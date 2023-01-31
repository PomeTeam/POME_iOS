//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class ReviewViewController: BaseTabViewController {
    
    //MARK: - Properties
    
    var currentGoal: Int = 0
    var goals = [GoalResponseModel](){
        didSet{
            if let cell = self.mainView.tableView.cellForRow(at: [0,0]) as? GoalTagsTableViewCell{
                cell.tagCollectionView.reloadData()
                mainView.tableView.reloadData()
            }
        }
    }
    var records = [RecordResponseModel](){
        didSet{
            mainView.tableView.reloadData()
        }
    }
    
    let mainView = ReviewView()
    
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
    
    @objc func filterButtonDidClicked(_ sender: UIButton){
        
        let sheet: EmotionFilterSheetViewController!
        
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        //TODO: Tag 활용하는 방식으로 변경하기
        if(sender == cell.firstEmotionFilter.filterButton){
            sheet = EmotionFilterSheetViewController.generateFirstEmotionFilterSheet()
        }else{
            sheet = EmotionFilterSheetViewController.generateSecondEmotionFilterSheet()
        }
        
        sheet.filterHandler = { emotion in
            guard let filterView = sender.superview as? ReviewFilterTableViewCell.EmotionFilterView,
                    let emotion = EmotionTag(rawValue: emotion) else { return }
            filterView.setFilterSelectState(emotion: emotion)
        }
        
        _ = sheet.loadAndShowBottomSheet(in: self)
    }
    
    @objc func reloadingButtonDidClicked(){
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        cell.firstEmotionFilter.setFilterDefaultState()
        cell.secondEmotionFilter.setFilterDefaultState()
    }
}

//MARK: - API

extension ReviewViewController{
    private func requestGetGoals(){
        GoalServcie.shared.getUserGoals{ [self] response in
            switch response{
            case .success(let data):
                goals = data.content
                requestGetRecords()
                break
            default:
                break
            }
        }
    }
    
    private func requestGetRecords(){
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        goals.count == 0 ? 1 : goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier, for: indexPath) as? GoalTagCollectionViewCell else { return UICollectionViewCell() }

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
        cell.setSelectState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalTagCollectionViewCell else { return }
        cell.setUnselectState()
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count + 3
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
            cell.reloadingButton.addTarget(self, action: #selector(reloadingButtonDidClicked), for: .touchUpInside)
            return cell
        default:
            //TODO: 기록 데이터 바인딩
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self)
            cell.mainView.firstEmotionTag.setTagInfo(when: .first, state: .happy)
            cell.mainView.secondEmotionTag.setTagInfo(when: .second, state: .sad)
            
//            if let reaction = records[indexPath.row] {
//                cell.mainView.myReactionButton.setImage(reaction.defaultImage, for: .normal)
//            }
//            cell.mainView.setOthersReaction(count: indexPath.row)
    //        cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReviewDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
