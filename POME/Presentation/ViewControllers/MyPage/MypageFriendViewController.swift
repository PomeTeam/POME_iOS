//
//  MypageFriendViewController.swift
//  POME
//
//  Created by gomin on 2022/11/28.
//

import UIKit

class MypageFriendViewController: BaseViewController {
    var friendTableView: UITableView!
    var friendsData: [FriendsResponseModel] = []

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        getFriends()
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
    @objc func showDeleteFriendDialog(_ sender: FriendTapGesture) {
        let dialog = ImageAlert.deleteFriend.generateAndShow(in: self)
        dialog.completion = {
            self.deleteFriend(sender.data?.friendNickName ?? "")
        }
    }
}
// MARK: - TableView delegate
extension MypageFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.friendsData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendSearchTableViewCell", for: indexPath) as? FriendSearchTableViewCell else { return UITableViewCell() }
        
        let itemIdx = indexPath.item
        if !self.friendsData.isEmpty {
            cell.setUpData(self.friendsData[itemIdx], false)
        }
        // 친구관리 > (-)버튼
        cell.rightButton.setImage(Image.minusRed, for: .normal)
        // 친구 삭제 Gesture
        let deleteFriendGesture = FriendTapGesture(target: self, action: #selector(showDeleteFriendDialog(_:)))
        deleteFriendGesture.data = self.friendsData[itemIdx]
        cell.rightButton.addGestureRecognizer(deleteFriendGesture)
        
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
//MARK: - API
extension MypageFriendViewController {
    // 친구 목록 조회
    private func getFriends() {
        let pageModel = PageableModel(page: 0)
        FriendService.shared.getFriends(pageable: pageModel) { result in
            switch result {
                case .success(let data):
                self.friendsData = data
                self.friendTableView.reloadData()
                    break
                case .failure(let err):
                print(err?.localizedDescription)
                    break
            default:
                break
            }
        }
    }

    // 친구 삭제
    private func deleteFriend(_ friendId: String) {
        FriendService.shared.deleteFriend(id: friendId) { result in
            switch result {
                case .success(let data):
                    if data.success {
                        print("친구 삭제 성공")
                        // 친구 목록 다시 불러오기
                        FriendListChangeManager.shared.isChange = true
                        self.getFriends()
                    }
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
            default:
                break
            }
        }
    }
}
