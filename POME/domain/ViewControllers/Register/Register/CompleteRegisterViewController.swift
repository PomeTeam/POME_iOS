//
//  CompleteRegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class CompleteRegisterViewController: UIViewController {
    // MARK: - Views
    let titleLabel = UILabel().then{
        $0.text = "회원가입 완료!\n친구를 추가해볼까요?"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .header1)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "친구의 소비 기록을 확인하고\n서로 응원할 수 있어요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let image = UIImageView().then{
        $0.image = Image.friendIllustrator
    }
    let nextTimeButton = DefaultButton(titleStr: "다음에 할래요", typo: .title3, backgroundColor: .white, titleColor: Color.grey4)
    let addButton = DefaultButton(titleStr: "추가할래요")

    // MARK: - Life Cycle
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

    // MARK: - Functions
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        initButton()
    }
    func layout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(image)
        self.view.addSubview(addButton)
        self.view.addSubview(nextTimeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
            make.leading.equalToSuperview().offset(16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        image.snp.makeConstraints { make in
            make.width.height.equalTo(270)
            make.centerX.centerY.equalToSuperview()
        }
        addButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-35)
        }
        nextTimeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addButton.snp.top).offset(-12)
        }
    }
    func initButton() {
        addButton.rx.tap
            .bind {
                let vc = FriendSearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        nextTimeButton.rx.tap
            .bind {
                self.navigationController?.pushViewController(TabBarController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
