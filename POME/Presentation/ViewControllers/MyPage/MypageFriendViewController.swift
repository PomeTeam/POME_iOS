//
//  MypageFriendViewController.swift
//  POME
//
//  Created by gomin on 2022/11/28.
//

import UIKit

class MypageFriendViewController: BaseViewController {
    var friendTableView: UITableView!

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "친구관리")
        
        setTableView()
        friendTableView.delegate = self
        friendTableView.dataSource = self
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(friendTableView)
        friendTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    // MARK: - Methods
    func setTableView() {
        friendTableView = UITableView().then{
            $0.register(FriendSearchTableViewCell.self, forCellReuseIdentifier: "FriendSearchTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @objc func showDeleteFriendDialog() {
        let dialog = ImagePopUpViewController(Image.trashPink, "친구를 삭제하시겠어요?", "친구의 씀씀이를 더 이상 볼 수 없어요", "삭제할게요", "아니요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
}
// MARK: - TableView delegate
extension MypageFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendSearchTableViewCell", for: indexPath) as? FriendSearchTableViewCell else { return UITableViewCell() }

        // 친구관리 > (-)버튼
        cell.rightButton.setImage(Image.minusRed, for: .normal)
        cell.rightButton.addTarget(self, action: #selector(showDeleteFriendDialog), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
