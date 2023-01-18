//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class ReviewViewController: BaseTabViewController {
    
    
    //MARK: - Properties
    /* goalCategoryList test 데이터
     1. [String]()
     2. ["카테고리","카페", "운동","고양이", "탐앤탐스으"]
     */
    
    var selectedGoalCategory: Int = 0
    
    var goalCategoryList: [String] = ["카테고리","카페", "운동","고양이", "탐앤탐스으"]
    
    var consumeList = [Reaction?](repeating: nil, count: 10){
        didSet{
            mainView.tableView.reloadData()
        }
    }
    
    let mainView = ReviewView()
    var emptyView: ReviewEmptyView!
    
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
            guard let filterView = sender.superview as? ReviewFilterTableViewCell.EmotionFilterView, let emotion = EmotionTag(rawValue: emotion) else { return }
            filterView.setFilterSelectState(emotion: emotion)
        }
        
        _ = sheet.loadAndShowBottomSheet(in: self)
    }
    
    @objc func reloadingButtonDidClicked(){
        
        guard let cell = mainView.tableView.cellForRow(at: [0,2]) as? ReviewFilterTableViewCell else { return }
        
        cell.firstEmotionFilter.setFilterDefaultState()
        cell.secondEmotionFilter.setFilterDefaultState()
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
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalCategoryList.count == 0 ? 1 : goalCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier, for: indexPath) as? GoalTagCollectionViewCell else { return UICollectionViewCell() }

        cell.goalCategoryLabel.text = goalCategoryList.isEmpty ? "···" : goalCategoryList[indexPath.row]
        
        if(selectedGoalCategory == indexPath.row){
            cell.setSelectState()
            return cell
        }
        
        cell.setUnselectState()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let testLabel = UILabel().then{
            $0.text = goalCategoryList.isEmpty ? "···" : goalCategoryList[indexPath.row]
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        }
        
        let width = testLabel.intrinsicContentSize.width + 12 * 2
        
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalTagCollectionViewCell else { return }
        if(selectedGoalCategory == 0 && indexPath.row != 0){
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
        if(consumeList.count == 0){
            emptyView = ReviewEmptyView()
            self.view.addSubview(emptyView)
            emptyView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalTo(mainView.tableView)
            }
        }else if(emptyView != nil){
            emptyView.removeFromSuperview()
            emptyView = nil
        }
        
        return consumeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalTagsTableViewCell.cellIdentifier, for: indexPath) as? GoalTagsTableViewCell else { return UITableViewCell() }
            cell.tagCollectionView.delegate = self
            cell.tagCollectionView.dataSource = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalDetailTableViewCell.cellIdentifier, for: indexPath) as? GoalDetailTableViewCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewFilterTableViewCell.cellIdentifier, for: indexPath) as? ReviewFilterTableViewCell else { return UITableViewCell() }
            cell.firstEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
            cell.secondEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
            cell.reloadingButton.addTarget(self, action: #selector(reloadingButtonDidClicked), for: .touchUpInside)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumeReviewTableViewCell.cellIdentifier, for: indexPath) as? ConsumeReviewTableViewCell else { return UITableViewCell() }
            cell.mainView.firstEmotionTag.setTagInfo(when: .first, state: .happy)
            cell.mainView.secondEmotionTag.setTagInfo(when: .second, state: .sad)
            
            if let reaction = consumeList[indexPath.row] {
                cell.mainView.myReactionBtn.setImage(reaction.defaultImage, for: .normal)
            }
            cell.mainView.setOthersReaction(count: indexPath.row)
    //        cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ReviewDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
