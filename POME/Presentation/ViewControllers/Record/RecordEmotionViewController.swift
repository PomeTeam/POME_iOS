//
//  RecordEmotionViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class RecordEmotionViewController: BaseViewController {
    var recordEmotionView = RecordEmotionView()
    var goalContent: GoalResponseModel?
    var noSecondEmotionRecord: [RecordResponseModel] = []
    // Cell Height
    var expendingCellContent = ExpandingTableViewCellContent()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let goalContent = goalContent {
            self.getNoSecondEmotionRecords(id: goalContent.id)
        }
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
    
    // MARK: - Actions
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
    // MARK: 더보기 버튼 - Dynamic Cell Height Method
    @objc func viewMoreButtonDidTap(_ sender: IndexPathTapGesture) {
        let content = expendingCellContent
        content.expanded = !content.expanded
        self.recordEmotionView.recordEmotionTableView.reloadRows(at: [sender.data], with: .automatic)
    }
}
// MARK: - TableView delegate
extension RecordEmotionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.noSecondEmotionRecord.count ?? 0
        count == 0 ? EmptyView(self.recordEmotionView.recordEmotionTableView).showEmptyView(Image.noting, "돌아볼 씀씀이가 없어요") : EmptyView(self.recordEmotionView.recordEmotionTableView).hideEmptyView()
        
        return 1 + count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordEmotionTableViewCell", for: indexPath) as? RecordEmotionTableViewCell else { return UITableViewCell() }
            if let goalContent = self.goalContent {
                cell.setUpData(goalContent, self.noSecondEmotionRecord.count ?? 0)
            }
            cell.selectionStyle = .none
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
            
            if !self.noSecondEmotionRecord.isEmpty {
                let itemIdx = indexPath.item - 1
                cell.setUpData(self.noSecondEmotionRecord[itemIdx])
            }
            
            // Alert Menu
            cell.menuButton.addTarget(self, action: #selector(alertRecordMenuButtonDidTap), for: .touchUpInside)
            // 더보기 버튼 클릭 Gesture
            let viewMoreGesture = IndexPathTapGesture(target: self, action: #selector(viewMoreButtonDidTap(_:)))
            viewMoreGesture.data = indexPath
            cell.viewMoreButton.addGestureRecognizer(viewMoreGesture)
            // Cell Height Set
            cell.settingHeight(isClicked: expendingCellContent)
            
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        if tag > 0 {
            let vc = SecondEmotionViewController()
            vc.recordId = self.noSecondEmotionRecord[indexPath.item - 1].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - API
extension RecordEmotionViewController {
    // MARK: 일주일이 지났고, 두 번째 감정이 없는 기록 조회 API
    private func getNoSecondEmotionRecords(id: Int) {
        RecordService.shared.getNoSecondEmotionRecords(id: id) { result in
            switch result{
            case .success(let data):
//                print("LOG: 일주일이 지났고, 두 번째 감정이 없는 기록 조회", data)
                
                self.noSecondEmotionRecord = data.content
                self.recordEmotionView.recordEmotionTableView.reloadData()

                break
            default:
                print(result)
                break
            }
        }
    }
}
