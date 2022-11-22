//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

//enum FilterType{
//
//    case first
//    case second
//
//    var title: String{
//        switch self{
//        case .first:        return "처음 감정"
//        case .second:       return "돌아본 감정"
//        }
//    }
//}

class ReviewViewController: BaseTabViewController {
    
    
    //MARK: - Properties
    /* goalCategoryList test 데이터
     1. [String]()
     2. ["카테고리","카페", "운동","고양이", "탐앤탐스으"]
     */
    
    var selectedGoalCategory: Int = 0
    
    var goalCategoryList: [String] = ["카테고리","카페", "운동","고양이", "탐앤탐스으"]
    
    let mainView = ReviewView().then{
        $0.firstEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
        $0.secondEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidClicked), for: .touchUpInside)
    }

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Method
    
    @objc func filterButtonDidClicked(_ sender: UIButton){
        
        let sheet: EmotionFilterSheetViewController!
        
        if(sender == mainView.firstEmotionFilter.filterButton){
            print("first click")
            sheet = EmotionFilterSheetViewController.generateFirstEmotionFilterSheet()
        }else{
            print("second click")
            sheet = EmotionFilterSheetViewController.generateSecondEmotionFilterSheet()
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
    
    //MARK: - Override
    
    override func style(){
        
        super.style()
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize(){
        mainView.goalTagCollectionView.delegate = self
        mainView.goalTagCollectionView.dataSource = self
        
        mainView.consumeTableView.separatorStyle = .none
        mainView.consumeTableView.delegate = self
        mainView.consumeTableView.dataSource = self
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalCategoryList.count == 0 ? 1 : goalCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCategoryCollectionViewCell.cellIdentifier, for: indexPath) as? GoalCategoryCollectionViewCell else { return UICollectionViewCell() }

        //TODO: CollectionView 첫 번째 셀로 기본 값 세팅
        
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalCategoryCollectionViewCell else { return }
        if(selectedGoalCategory == 0 && indexPath.row != 0){
            guard let cell = collectionView.cellForItem(at: [0,0]) as? GoalCategoryCollectionViewCell else { return }
            cell.setUnselectState()
        }
        cell.setSelectState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalCategoryCollectionViewCell else { return }
        cell.setUnselectState()
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumeReviewTableViewCell.cellIdentifier, for: indexPath) as? ConsumeReviewTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ReviewDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
