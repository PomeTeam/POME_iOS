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
    var name = BehaviorRelay(value: "")

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func style() {
        super.style()
        
        friendSearchView = FriendSearchView()
        friendSearchView.setTableView(dataSourceDelegate: self)
        friendSearchView.searchTableView.keyboardDismissMode = .onDrag
        
        initNameTextField()
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
    func initNameTextField() {
        // editingChanged 이벤트가 발생 했을 때
        friendSearchView.searchTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                self.friendSearchView.showEmptyView()
                print("editingChanged : \(self.friendSearchView.searchTextField.text ?? "")")
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
                print("name changed : \(newValue) ")
            })
            .disposed(by: disposeBag)
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
