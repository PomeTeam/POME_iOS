//
//  DeleteUserViewController.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import UIKit

class DeleteUserViewController: BaseViewController {
    var deleteUserView: DeleteUserView!
    var cellTitleArray = ["기록이 귀찮아요", "알림이 너무 많이 와요", "억울하게 이용이 제한됐어요", "새 계정을 만들고 싶어요"]
    var selectedIdx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "탈퇴하기")
    }
    override func layout() {
        super.layout()
        
        deleteUserView = DeleteUserView()
        self.view.addSubview(deleteUserView)
        deleteUserView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        self.deleteUserView.deleteUserTableView.delegate = self
        self.deleteUserView.deleteUserTableView.dataSource = self
        
        deleteUserView.completeButton.rx.tap
            .bind {
                self.navigationController?.pushViewController(DeleteUserDetailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - TableView delegate
extension DeleteUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteUserTableViewCell", for: indexPath) as? DeleteUserTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setUpTitle(cellTitleArray[indexPath.row])
        
        cell.checkButton.isSelected = indexPath.row == self.selectedIdx ?? -1 ? true : false
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54 + 12
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIdx = indexPath.row
        self.deleteUserView.deleteUserTableView.reloadData()
        
        self.deleteUserView.completeButton.isActivate = true
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
