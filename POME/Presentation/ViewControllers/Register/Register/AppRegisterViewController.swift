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
    var inputCode = BehaviorRelay(value: "")
    var authCode = ""
    
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
        initTextField()
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
    // TextFields
    func initTextField() {
        appRegisterView.phoneTextField.delegate = self
        appRegisterView.codeTextField.delegate = self
        
        self.appRegisterView.phoneTextField.rx.text.orEmpty
                            .distinctUntilChanged()
                            .bind(to: self.phone)
                            .disposed(by: disposeBag)
        
        self.appRegisterView.codeTextField.rx.text.orEmpty
                            .distinctUntilChanged()
                            .bind(to: self.inputCode)
                            .disposed(by: disposeBag)
    }
    // Buttons
    func initButton() {
        // 인증번호 요청 버튼
        appRegisterView.codeSendButton.rx.tap
            .bind {self.codeSendButtonDidTap()}
            .disposed(by: disposeBag)
        
        // 동의하고 시작하기 버튼
        appRegisterView.nextButton.rx.tap
            .bind {self.nextButtonDidTap()}
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc func codeSendButtonDidTap() {
        appRegisterView.codeSendButton.isSelected = true
        sendSMS()
    }
    @objc func nextButtonDidTap() {
        if inputCode.value == self.authCode {
            self.navigationController?.pushViewController(TermsViewController(), animated: true)
        } else {
            // TODO: 코드가 맞지 않을 때 예외처리
            print("🤩보내진 인증코드와 입력한 코드번호가 맞지 않습니다.🤩")
        }
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
//MARK: - API
extension AppRegisterViewController {
    private func sendSMS(){
        let sendSMSRequestModel = SendSMSRequestModel(phoneNum: self.phone.value)
        UserService.shared.sendSMS(model: sendSMSRequestModel) { result in
            switch result {
                case .success(let data):
                    print("인증번호 전송 성공")
                    guard let authCode = data.data?.value else {return}
                    self.authCode = authCode
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
