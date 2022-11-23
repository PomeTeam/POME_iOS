//
//  AllRecordsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import UIKit

class AllRecordsViewController: BaseViewController {
    var allRecordsView: AllRecordsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    // MARK: - Actions
    @objc func alertRecordMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            print("click modify")
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImagePopUpViewController(Image.trashGreen, "기록을 삭제하시겠어요?", "삭제한 내용은 다시 되돌릴 수 없어요", "삭제할게요", "아니요")
            dialog.modalPresentationStyle = .overFullScreen
            self.present(dialog, animated: false, completion: nil)
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
            let dialog = ImagePopUpViewController(Image.trashGreen, "목표를 삭제하시겠어요?", "해당 목표에서 작성한 기록도 모두 삭제돼요", "삭제할게요", "아니요")
            dialog.modalPresentationStyle = .overFullScreen
            self.present(dialog, animated: false, completion: nil)
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
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
        // Alert Menu
        cell.menuButton.addTarget(self, action: #selector(alertRecordMenuButtonDidTap), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
