//
//  RecordViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//
import UIKit
import CloudKit

class RecordViewController: BaseTabViewController {
    var recordView = RecordView()
    // Goal Category
    var categories: [GoalCategoryResponseModel] = []
    var categorySelectedIdx = 0
    // Goal Content
    var goalContent: [GoalResponseModel] = []
    // Records
    var recordsOfGoal: [RecordResponseModel] = []
    var noSecondEmotionRecords: [RecordResponseModel] = []

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
        if self.goalContent.isEmpty {
            let sheet = RecordBottomSheetViewController(Image.flagMint, "지금은 씀씀이를 기록할 수 없어요", "나만의 소비 목표를 설정하고\n기록을 시작해보세요!")
            sheet.loadViewIfNeeded()
            self.present(sheet, animated: true, completion: nil)
        } else {
            let vc = RecordRegisterContentViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func finishGoalButtonDidTap(_ sender: GoalTapGesture) {
        let vc = AllRecordsViewController()
        vc.goalContent = sender.data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addGoalButtonDidTap() {
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
    @objc func alertGoalMenuButtonDidTap(_ sender: GoalTapGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteInProgressGoal.generateAndShow(in: self)
            dialog.completion = {
                self.deleteGoal(id: sender.data?.id ?? 0)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    @objc func alertRecordMenuButtonDidTap(_ sender: RecordTapGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            print("click modify")
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteRecord.generateAndShow(in: self)
            dialog.completion = {
                self.deleteRecord(id: sender.data?.id ?? 0)
            }
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
        else if isGoalDateEnd(goalContent[itemIdx]) {cell.setInactivateState()} // 기한이 지난 목표일 때
        else {cell.setUnselectState()}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let itemIdx = indexPath.row
        self.categorySelectedIdx = itemIdx
        
        // 기간이 지난 목표
        if isGoalDateEnd(goalContent[itemIdx]) || self.noSecondEmotionRecords.count == 0 {self.showGoalFinishWarning()}
        
        // 목표에 저장된 씀씀이 조회
        getRecordsOfGoal(id: goalContent[itemIdx].id, page: 0, size: 10)
        
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
            cell.goalPlusButton.addTarget(self, action: #selector(addGoalButtonDidTap), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
            
            if !self.goalContent.isEmpty {
                cell.setUpData(self.goalContent[self.categorySelectedIdx])
                // Alert Menu
                let deleteGoalGesture = GoalTapGesture(target: self, action: #selector(alertGoalMenuButtonDidTap(_:)))
                deleteGoalGesture.data = self.goalContent[self.categorySelectedIdx]
                cell.menuButton.addGestureRecognizer(deleteGoalGesture)
            }
            
            cell.selectionStyle = .none
            
            // MARK: 목표가 존재하지 않을 때
            if self.categories.count == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyGoalTableViewCell", for: indexPath) as? EmptyGoalTableViewCell else { return UITableViewCell() }
                cell.makeGoalButton.addTarget(self, action: #selector(addGoalButtonDidTap), for: .touchUpInside)
                return cell
            }
            
            // MARK: 기간이 지난 목표 셀
            if isGoalDateEnd(goalContent[self.categorySelectedIdx]) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinishGoalTableViewCell", for: indexPath) as? FinishGoalTableViewCell else { return UITableViewCell() }
                let finishGoalGesture = GoalTapGesture(target: self, action: #selector(finishGoalButtonDidTap(_:)))
                finishGoalGesture.data = self.goalContent[self.categorySelectedIdx]
                cell.finishGoalButton.addGestureRecognizer(finishGoalGesture)
                return cell
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoEmotionBannerTableViewCell", for: indexPath) as? GoEmotionBannerTableViewCell else { return UITableViewCell() }
            cell.setUpCount(self.noSecondEmotionRecords.count ?? 0)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
            let itemIdx = indexPath.item - 3
            cell.setUpData(self.recordsOfGoal[itemIdx])
            // Alert Menu
            let deleteRecordGesture = RecordTapGesture(target: self, action: #selector(alertRecordMenuButtonDidTap(_:)))
            deleteRecordGesture.data = self.recordsOfGoal[itemIdx]
            cell.menuButton.addGestureRecognizer(deleteRecordGesture)
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        if tag == 2 {
            let vc = RecordEmotionViewController()
            vc.goalContent = self.goalContent[self.categorySelectedIdx]
            vc.noSecondEmotionRecord = self.noSecondEmotionRecords
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tag > 2 {
             cannotAddEmotionDidTap()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - API
extension RecordViewController {
    private func requestGetGoals(){
        // api 호출할 때마다 Goal 배열 초기화
        self.goalContent.removeAll()
        self.categories.removeAll()
        GoalService.shared.getUserGoals{ result in
            switch result{
            case .success(let data):
                for x in data.content {
                    if !x.isEnd {
                        self.goalContent.append(x)
                        self.categories.append(x.goalCategoryResponse)
                    }
                }
                // 목표에 맞는 기록들 조회
                if !self.goalContent.isEmpty {
                    self.getRecordsOfGoal(id: self.goalContent[self.categorySelectedIdx].id, page: 0, size: 10)
                }
                self.recordView.recordTableView.reloadData()
                
                break
            default:
                print(result)
                break
            }
        }
    }
    private func deleteGoal(id: Int){
        GoalService.shared.deleteGoal(id: id) { result in
            switch result{
            case .success(let data):
                if data.success! {
                    print("목표 삭제 성공")
                    self.categorySelectedIdx = 0
                    self.noSecondEmotionRecords.removeAll()
                    self.requestGetGoals()
                }
                break
            default:
                print(result)
                break
            }
        }
    }
    private func getRecordsOfGoal(id: Int, page: Int, size: Int) {
        RecordService.shared.getRecordsOfGoal(id: id, pageable: PageableModel(page: page)) { result in
            switch result{
            case .success(let data):
//                print("LOG: 씀씀이 조회", data.content)
                self.recordsOfGoal = data.content
                
                self.noSecondEmotionRecords.removeAll()
                // 두번째 감정이 없는 기록 갯수
                for x in data.content {
                    if x.emotionResponse.secondEmotion == nil || x.emotionResponse.secondEmotion == 3 {
                        self.noSecondEmotionRecords.append(x)
                    }
                }
                self.recordView.recordTableView.reloadData()
                
                break
            default:
                print(result)
                break
            }

        }
    }
    private func deleteRecord(id: Int) {
        RecordService.shared.deleteRecord(id: id) { result in
            print("기록 삭제 성공")
            self.requestGetGoals()
        }
    }
    private func isGoalDateEnd(_ data: GoalResponseModel) -> Bool {
        let endDate = data.endDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let convertDate = dateFormatter.date(from: endDate)
        
        // 종료 날짜가 오늘보다 이전인 지 확인
        let result: ComparisonResult = Date().compare(convertDate ?? .now)
        if result == .orderedDescending {
            return true
        } else {
            return false
        }
    }
}
