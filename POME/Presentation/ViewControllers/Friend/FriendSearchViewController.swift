//
//  FriendSearchViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class FriendSearchViewController: BaseViewController {
    var friendSearchView: FriendSearchView!
    var name = BehaviorRelay(value: "")
    var friendData: [FriendsResponseModel] = []
    var isFromRegister: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "친구 추가")
        
        friendSearchView = FriendSearchView()
        friendSearchView.setTableView(dataSourceDelegate: self)
        friendSearchView.searchTableView.keyboardDismissMode = .onDrag
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(friendSearchView)
        friendSearchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
    }
    override func initialize() {
        super.initialize()
        
        initNameTextField()
        initButton()
    }
    func initNameTextField() {
        // editingChanged 이벤트가 발생 했을 때
        friendSearchView.searchTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                
//                print("editingChanged : \(self.friendSearchView.searchTextField.text ?? "")")
            }).disposed(by: disposeBag)
        
        // textField.rx.text의 변경이 있을 때
        self.friendSearchView.searchTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .map({ name in
                        return self.setValidName(name)
                    })
                    .bind(to: self.name)
                    .disposed(by: disposeBag)
                
        self.name.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.searchFriend(id: newValue)
//                print("name changed : \(newValue) ")
            })
            .disposed(by: disposeBag)
    }
    func initButton() {
        friendSearchView.completeButton.rx.tap
            .bind {
                self.completeButtonDidTap()
            }
            .disposed(by: disposeBag)
        friendSearchView.completeButtonBottom.rx.tap
            .bind {
                self.completeButtonDidTap()
            }
            .disposed(by: disposeBag)
    }
    // 이전 화면에 따라 다르게 화면 전환 구분
    // 1. 회원가입 진행 중 친구 추가했을 때: '완료했어요' 클릭 시 기록 탭으로 이동
    // 2. 친구 탭에서 친구 추가했을 때: '완료했어요' 클릭 시 친구 탭(이전 화면)으로 이동
    // '완료했어요' 버튼 클릭 Event
    func completeButtonDidTap() {
        if self.isFromRegister {
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setValidName(_ nameStr: String) -> String {
        var currName = nameStr
        if nameStr.count <= 10 {
            currName = nameStr.filter {!($0.isWhitespace)}
        } else {
            currName = self.name.value
            self.view.endEditing(true)
        }
        self.friendSearchView.searchTextField.text = currName
        return currName
    }
    func setFriendSearchEmptyView() {
        let count = self.friendData.count ?? 0
        print("count:", count)
        if count == 0 {
            EmptyView(self.friendSearchView.searchTableView).setCenterEmptyView(Image.warning, "검색 결과가 없어요\n다른 닉네임으로 검색해볼까요?")
        } else {
            EmptyView(self.friendSearchView.searchTableView).hideEmptyView()
        }
    }
}
// MARK: - TableView delegate
extension FriendSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.friendData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendSearchTableViewCell", for: indexPath) as? FriendSearchTableViewCell else { return UITableViewCell() }
        
        let itemIdx = indexPath.item
        cell.setUpData(self.friendData[itemIdx], true)
        
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - API
extension FriendSearchViewController {
    private func searchFriend(id: String){
        if id.isEmpty {
            self.friendData.removeAll()
            self.friendSearchView.searchTableView.reloadData()
            self.friendSearchView.searchTableView.backgroundView?.isHidden = true
            return
        }
        FriendService.shared.getFriendSearch(id: id) { result in
            switch result {
                case .success(let data):
                    print("친구 찾기:", id)
                    print(data.data)
                
                    self.friendData = data.data ?? []
                    self.setFriendSearchEmptyView()
                    self.friendSearchView.searchTableView.reloadData()
                
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
