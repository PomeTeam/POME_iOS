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
                                               sendCodeButtonControlEvent: appRegisterView.codeSendButton.rx.tap,
                                               nextButtonControlEvent: appRegisterView.nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        // 인증번호 발송 버튼 활성화 유무
        output.ctaSendCodeButtonActivate
            .drive(appRegisterView.codeSendButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        // '동의하고 시작하기' 버튼 활성화 유무
        output.ctaButtonActivate
            .drive(appRegisterView.nextButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        // 로그인 후 기록탭으로 이동
        output.user.bind { _ in
            self.moveToRecordTab()
        }.disposed(by: disposeBag)
        
        // 유저가 아닐 시 회원가입 페이지 이동
        output.signUp.bind{
            if $0 {self.moveToRegister()}
        }.disposed(by: disposeBag)
        
        // 인증번호 에러메세지 출력
        output.codeMatch
            .drive(appRegisterView.errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    // MARK: - Functions
    func initTextField() {
        appRegisterView.phoneTextField.delegate = self
        appRegisterView.codeTextField.delegate = self
    }
    func initButton() {
        // 인증번호가 오지 않나요?
        appRegisterView.notSendedButton.rx.tap
            .bind {LinkManager(self, .codeError)}
            .disposed(by: disposeBag)
    }
    func moveToRecordTab() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {return}
        delegate.window?.rootViewController = TabBarController()
    }
    func moveToRegister() {
        let vc = TermsViewController()
        vc.phoneNum = self.viewModel.phoneNumRelay.value ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITextField Delegate
extension AppRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setFocusState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnfocusState()
    }
}
