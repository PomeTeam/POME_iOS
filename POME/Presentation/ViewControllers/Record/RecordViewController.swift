//
//  RecordViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//
import UIKit

class RecordViewController: BaseTabViewController {
    var recordView = RecordView()
    // Goal Category
    var categories: [GoalCategoryResponseModel] = []
    var categorySelectedIdx = 0
    // Goal Content
    var goalContent: [GoalResponseModel] = []
    
    // Records (임시)
    var recordsOfGoal: [GoalCategoryResponseModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        requestGetGoals()
    }
    override func style() {
        super.style()
        
        recordView.recordTableView.delegate = self
        recordView.recordTableView.dataSource = self
        EmptyView(recordView.recordTableView).showEmptyView(Image.noting, "기록한 씀씀이가 없어요")
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        recordView.writeButton.addTarget(self, action: #selector(writeButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    @objc func writeButtonDidTap() {
        //TODO: 소비 기록 등록/소비 등록 제한 코드 분리
        let vc = RecordRegisterContentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        let sheet = RecordBottomSheetViewController(Image.flagMint, "지금은 씀씀이를 기록할 수 없어요", "나만의 소비 목표를 설정하고\n기록을 시작해보세요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
         */
    }
    @objc func cannotAddGoalButtonDidTap() {
        //TODO: 목표 등록/개수 제한 팝업 코드 분리
        let vc = GoalDateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
       
        /*
        let sheet = RecordBottomSheetViewController(Image.ten, "목표는 10개를 넘을 수 없어요", "포미는 사용자가 무리하지 않고 즐겁게 목표를\n달성할 수 있도록 응원하고 있어요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
         */
    }
    func cannotAddEmotionDidTap() {
        let sheet = RecordBottomSheetViewController(Image.penPink, "아직은 감정을 기록할 수 없어요", "일주일이 지나야 감정을 남길 수 있어요\n나중에 다시 봐요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
    @objc func alertGoalMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteInProgressGoal.generateAndShow(in: self)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    @objc func alertRecordMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            print("click modify")
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteRecord.generateAndShow(in: self)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    func showGoalFinishWarning() {
        let sheet = RecordBottomSheetViewController(Image.penPink,
                                                    "아직 돌아보지 않은 기록이 있어요!",
                                                    "씀씀이 기록 후 일주일 뒤에\n감정을 돌아보고 목표를 종료할 수 있어요")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
}
//MARK: - CollectionView Delegate
extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.categories.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalTagCollectionViewCell.cellIdentifier, for: indexPath)
                as? GoalTagCollectionViewCell else { fatalError() }
        
        let itemIdx = indexPath.row
        cell.goalCategoryLabel.text = categories[itemIdx].name
        
        if itemIdx == self.categorySelectedIdx {cell.setSelectState()}
        else if goalContent[itemIdx].isEnd {cell.setInactivateState()} // 종료된 목표일 시
        else {cell.setUnselectState()}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let itemIdx = indexPath.row
        self.categorySelectedIdx = itemIdx
        
        if goalContent[itemIdx].isEnd {self.showGoalFinishWarning()}
        self.recordView.recordTableView.reloadData()
        
        return true
    }
    // 글자수에 따른 셀 너비 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categories[indexPath.item].name.size(withAttributes: [NSAttributedString.Key.font : UIFont.autoPretendard(type: .sb_14)]).width + 32, height: 29)
    }
    
}
// MARK: - TableView delegate
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = recordsOfGoal.count ?? 0
        return 3 + count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCategoryTableViewCell", for: indexPath) as? GoalCategoryTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.goalCollectionView.delegate = self
            cell.goalCollectionView.dataSource = self
            cell.goalCollectionView.reloadData()
            
            // Add Goal
            cell.goalPlusButton.addTarget(self, action: #selector(cannotAddGoalButtonDidTap), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
            
            if !self.goalContent.isEmpty {
                cell.setUpData(self.goalContent[self.categorySelectedIdx])
            }
            // Alert Menu
            cell.menuButton.addTarget(self, action: #selector(alertGoalMenuButtonDidTap), for: .touchUpInside)
            cell.selectionStyle = .none
            
            // MARK: 목표가 존재하지 않을 때
            if self.categories.count == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyGoalTableViewCell", for: indexPath) as? EmptyGoalTableViewCell else { return UITableViewCell() }
                cell.makeGoalButton.addTarget(self, action: #selector(writeButtonDidTap), for: .touchUpInside)
                return cell
            }
            
            /* 셀 작업 위해 임시로 주석 처리
            // MARK: 목표 종료 셀
            if goalContent[self.categorySelectedIdx].isEnd {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinishGoalTableViewCell", for: indexPath) as? FinishGoalTableViewCell else { return UITableViewCell() }
                return cell
            }
             */
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoEmotionBannerTableViewCell", for: indexPath) as? GoEmotionBannerTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
            // Alert Menu
            cell.menuButton.addTarget(self, action: #selector(alertRecordMenuButtonDidTap), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        if tag == 2 {
            self.navigationController?.pushViewController(RecordEmotionViewController(), animated: true)
        } else if tag > 2 {
            // 감정을 남길 수 없을 때
            // cannotAddEmotionDidTap()
            self.navigationController?.pushViewController(SecondEmotionViewController(), animated: true)
        } else if tag == 1 {
            if self.categorySelectedIdx == 4 {
                self.navigationController?.pushViewController(AllRecordsViewController(), animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - API
extension RecordViewController {
    private func requestGetGoals(){
        // api 호출할 때마다 Goal Category 배열 초기화
        self.categories.removeAll()
        GoalServcie.shared.getUserGoals{ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGetGoals", data.content)
                self.goalContent = data.content
                for x in data.content {
                    self.categories.append(x.goalCategoryResponse)
                }
                self.recordView.recordTableView.reloadData()
                
                break
            default:
                print(result)
                break
            }
        }
    }
}
