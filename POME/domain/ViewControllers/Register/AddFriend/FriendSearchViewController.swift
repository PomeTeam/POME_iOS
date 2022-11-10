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
    let navigationTitle = UILabel().then{
        $0.text = "친구 추가"
        $0.font = UIFont.autoPretendard(type: .sb_14)
        $0.textColor = Color.grey_9
    }
    
    var friendSearchView: FriendSearchView!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func style() {
        super.style()
        
        friendSearchView = FriendSearchView()
        friendSearchView.setTableView(dataSourceDelegate: self)
        friendSearchView.searchTableView.keyboardDismissMode = .onDrag
        
        initButton()
    }
    override func layout() {
        super.layout()
        
        super.navigationView.addSubview(navigationTitle)
        navigationTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        self.view.addSubview(friendSearchView)
        friendSearchView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
    }
    func initButton() {
        friendSearchView.searchButton.rx.tap
            .bind {
                print("click!")
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - TableView delegate
extension FriendSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendSearchTableViewCell", for: indexPath) as? FriendSearchTableViewCell else { return UITableViewCell() }
        
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
