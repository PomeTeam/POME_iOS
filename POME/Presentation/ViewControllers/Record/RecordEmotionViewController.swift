//
//  RecordEmotionViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class RecordEmotionViewController: BaseViewController {
    var recordEmotionView = RecordEmotionView()
    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 1
    }
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
    
//    // MARK: 더보기 버튼 - Dynamic Cell Height Method
//    @objc func viewMoreButtonDidTap(_ sender: IndexPathTapGesture) {
//        let content = expendingCellContent
//        content.expanded = !content.expanded
//        self.recordEmotionView.recordEmotionTableView.reloadRows(at: [sender.data], with: .automatic)
//    }
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
            let cardIndex = dataIndexBy(indexPath)
            let record = self.noSecondEmotionRecord[cardIndex]
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConsumeReviewTableViewCell.self).then{
                $0.delegate = self
                $0.bindingData(with: record)
            }
            return cell
            
//            // 더보기 버튼 클릭 Gesture
//            let viewMoreGesture = IndexPathTapGesture(target: self, action: #selector(viewMoreButtonDidTap(_:)))
//            viewMoreGesture.data = indexPath
//            cell.viewMoreButton.addGestureRecognizer(viewMoreGesture)
//            // Cell Height Set
//            cell.settingHeight(isClicked: expendingCellContent)
//
//            cell.selectionStyle = .none
//            return cell
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
// MARK: - Record Cell delegate
extension RecordEmotionViewController: RecordCellDelegate{
    func presentReactionSheet(indexPath: IndexPath) {
        let data = noSecondEmotionRecord[dataIndexBy(indexPath)].friendReactions
        FriendReactionSheetViewController(reactions: data).show(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {
        let recordIndex = dataIndexBy(indexPath)

        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default){ _ in
            alert.dismiss(animated: true)
            
            guard let goalContent = self.goalContent else {return}
            let vc = ModifyRecordViewController(goal: goalContent,
                                                       record: self.noSecondEmotionRecord[recordIndex])
//            {
//                self.noSecondEmotionRecord[recordIndex] = $0
//            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            let alert = ImageAlert.deleteRecord.generateAndShow(in: self)
            alert.completion = {
                self.deleteRecord(id: self.noSecondEmotionRecord[recordIndex].id)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
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
                NetworkAlert.show(in: self){ [weak self] in
                    self?.getNoSecondEmotionRecords(id: id)
                }
                break
            }
        }
    }
    // MARK: 기록 삭제 API
    private func deleteRecord(id: Int) {
        RecordService.shared.deleteRecord(id: id) { result in
            print("기록 삭제 성공")
            self.getNoSecondEmotionRecords(id: self.goalContent?.id ?? 0)
        }
    }
}
