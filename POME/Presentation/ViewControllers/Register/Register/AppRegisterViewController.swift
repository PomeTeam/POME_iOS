//
//  AppRegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class AppRegisterViewController: BaseViewController {
    var appRegisterView: AppRegisterView!
    private let viewModel = AppRegisterViewModel()
    
    var phone = BehaviorRelay(value: "")
    var code = BehaviorRelay(value: "")
    
    var isValidPhone = false
    var isValidCode = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func layout() {
        super.layout()
        
        appRegisterView = AppRegisterView()
        self.view.addSubview(appRegisterView)
        appRegisterView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        // TextField
        appRegisterView.phoneTextField.delegate = self
        appRegisterView.codeTextField.delegate = self
        
        initButton()
    }
    override func bind() {
        let input = AppRegisterViewModel.Input(phoneTextField: appRegisterView.phoneTextField.rx.text.orEmpty.asObservable(),
                                               codeTextField: appRegisterView.codeTextField.rx.text.orEmpty.asObservable(),
                                               nextButtonControlEvent: appRegisterView.nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.canMoveNext
            .drive(appRegisterView.nextButton.rx.isActivate)
            .disposed(by: disposeBag)
    }
    // MARK: - Functions
    func initButton() {
        // 인증번호 요청 버튼
        appRegisterView.codeSendButton.rx.tap
            .bind {self.codeSendButtonDidTap()}
            .disposed(by: disposeBag)
        // 동의하고 시작하기 버튼
        appRegisterView.nextButton.rx.tap
            .bind {
                self.navigationController?.pushViewController(TermsViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc func codeSendButtonDidTap() {
        appRegisterView.codeSendButton.isSelected = true
    }
}
extension AppRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
