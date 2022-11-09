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
                print("serata!")
            }
            .disposed(by: disposeBag)
    }
}
