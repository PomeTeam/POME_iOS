//
//  NotificationViewController.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class NotificationViewController: BaseViewController {
    var notiTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func style() {
        super.style()
        super.titleLabel.text = "알림"
        
        setTableView()
        notiTableView.delegate = self
        notiTableView.dataSource = self
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(notiTableView)
        notiTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    func setTableView() {
        notiTableView = UITableView().then{
            $0.register(NotiTableViewCell.self, forCellReuseIdentifier: "NotiTableViewCell")
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.transparent
            
            $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
// MARK: - TableView delegate
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiTableViewCell", for: indexPath) as? NotiTableViewCell else { return UITableViewCell() }
//        cell.setComplete()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
