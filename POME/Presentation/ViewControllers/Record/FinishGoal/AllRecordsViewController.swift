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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRecordsOfGoal(id: self.goalContent?.id ?? 0, page: 0, size: 15)
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
        cell.menuButton.addTarget(self, action: #selector(alertRecordMenuButtonDidTap), for: .touchUpInside)
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
                print("LOG: 씀씀이 조회", data)
                self.recordsOfGoal = data
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
}
