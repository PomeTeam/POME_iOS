//
//  AllRecordsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import UIKit

// 목표 종료 시 나타나는 뷰컨
class AllRecordsViewController: BaseViewController {
    var allRecordsView: AllRecordsView!
    var goalContent: GoalResponseModel?
    var recordsOfGoal: [RecordResponseModel] = []
    
    var preVC: RecordViewController!
    var isGoalDeleted: Bool = false

    init(_ preVC: RecordViewController){
        self.preVC = preVC
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRecordsOfGoal(id: self.goalContent?.id ?? 0, page: 0, size: 15)
        print("기한이 지난 목표:", self.goalContent?.id ?? 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isGoalDeleted {
            self.preVC.categorySelectedIdx = 0
        }
    }
    
    override func style() {
        super.style()
        
        allRecordsView = AllRecordsView()
        allRecordsView.allRecordsTableView.delegate = self
        allRecordsView.allRecordsTableView.dataSource = self
        EmptyView(allRecordsView.allRecordsTableView).showEmptyView(Image.noting, "기록한 씀씀이가 없어요")
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(allRecordsView)
        allRecordsView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        allRecordsView.goalView.menuButton.addTarget(self, action: #selector(alertGoalMenuButtonDidTap), for: .touchUpInside)
        allRecordsView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func nextButtonDidTap() {
        let vc = CommentViewController()
        vc.goalContent = self.goalContent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func alertRecordMenuButtonDidTap(_ sender: RecordTapGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            guard let goalData = self.goalContent else {return}
            guard let recordData = sender.data else {return}
            let vc = RecordModifyContentViewController(goal: goalData,
                                                       record: recordData){_ in
                print("click modify")
            }
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func alertGoalMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteInProgressGoal.generateAndShow(in: self)
            dialog.completion = {
                self.deleteGoal(id: self.goalContent?.id ?? 0)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - TableView delegate
extension AllRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.recordsOfGoal.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
        // Set Data
        let itemIdx = indexPath.item
        cell.setUpData(self.recordsOfGoal[itemIdx])
        // Alert Menu
        let tapRecordMenuGesture = RecordTapGesture(target: self, action: #selector(alertRecordMenuButtonDidTap(_:)))
        tapRecordMenuGesture.data = self.recordsOfGoal[itemIdx]
        cell.menuButton.addGestureRecognizer(tapRecordMenuGesture)
        
        cell.selectionStyle = .none
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondEmotionViewController()
        vc.recordId = self.recordsOfGoal[indexPath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API
extension AllRecordsViewController {
    private func getRecordsOfGoal(id: Int, page: Int, size: Int) {
        RecordService.shared.getRecordsOfGoalAtRecordTab(id: id, pageable: PageableModel(page: page)) { result in
            switch result{
            case .success(let data):
                print("LOG: 기한이 지난 목표의 기록 조회 (일주일이 지나지 않은)", data)
                self.recordsOfGoal = data.content
                self.allRecordsView.allRecordsTableView.reloadData()
                self.setUpContent()
                
                break
            default:
                print(result)
                break
            }
        }
    }
    private func setUpContent() {
        self.allRecordsView.countLabel.text = "전체 \(self.recordsOfGoal.count)건"
        if let goalContent = self.goalContent {
            self.allRecordsView.goalView.setUpContent(goalContent)
        }
    }
    // MARK: 목표 삭제 API
    private func deleteGoal(id: Int){
        GoalService.shared.deleteGoal(id: id) { result in
            switch result{
            case .success(let data):
                if data.success {
                    print("목표 삭제 성공")
                    self.isGoalDeleted = true
                    self.navigationController?.popViewController(animated: true)
                }
                break
            default:
                print(result)
                break
            }
        }
    }
    // MARK: 기록 삭제 API
    private func deleteRecord(id: Int) {
        RecordService.shared.deleteRecord(id: id) { result in
            print("기록 삭제 성공")
            self.getRecordsOfGoal(id: self.goalContent?.id ?? 0, page: 0, size: 15)
        }
    }
}
