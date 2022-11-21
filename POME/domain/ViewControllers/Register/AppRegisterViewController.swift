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
    var name = BehaviorRelay(value: "")
    var phone = BehaviorRelay(value: "")
    var code = BehaviorRelay(value: "")
    
    var isValidName = false
    var isValidPhone = false
    var isValidCode = false
    
    let disposeBag = DisposeBag()

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
        appRegisterView.nameTextField.delegate = self
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
                self.navigationController?.pushViewController(AppRegisterViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    func initTextField() {
        self.appRegisterView.nameTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .bind(to: self.name)
                    .disposed(by: disposeBag)
        
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
        self.name.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.isValidName = self.isValidName(newValue)
                self.isValidContent()
            })
            .disposed(by: disposeBag)
        
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
    func isValidName(_ name: String) -> Bool {
        return name.count > 0 ? true : false
    }
    func isValidPhone(_ phone: String) -> Bool {
        return phone.count > 0 ? true : false
    }
    func isValidCode(_ code: String) -> Bool {
        return code.count > 0 ? true : false
    }
    func isValidContent() {
        let isValidContent = self.isValidName && self.isValidPhone && self.isValidCode ? true : false
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
