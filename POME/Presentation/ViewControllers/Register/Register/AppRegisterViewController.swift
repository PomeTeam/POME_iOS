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
        
        initTextField()
        initButton()
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
    func initTextField() {
        
        self.appRegisterView.phoneTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .bind(to: self.phone)
                    .disposed(by: disposeBag)
        
        self.appRegisterView.codeTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .bind(to: self.code)
                    .disposed(by: disposeBag)
        
        initProperties()
    }
    func initProperties() {
        
        self.phone.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.isValidPhone = self.isValidPhone(newValue)
                self.isValidContent()
            })
            .disposed(by: disposeBag)
        
        self.code.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.isValidCode = self.isValidCode(newValue)
                self.isValidContent()
            })
            .disposed(by: disposeBag)
    }
    func isValidPhone(_ phone: String) -> Bool {
        let pattern = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: phone, options: [], range: NSRange(location: 0, length: phone.count)) {
            return true
        } else {
            return false
        }
    }
    func isValidCode(_ code: String) -> Bool {
        return code.count > 0 ? true : false
    }
    func isValidContent() {
        let isValidContent = self.isValidPhone && self.isValidCode ? true : false
        appRegisterView.nextButton.isActivate(isValidContent)
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
