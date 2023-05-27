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
    var isUser = false

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
        
        output.canSendCode
            .drive(appRegisterView.codeSendButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        output.canMoveNext
            .drive(appRegisterView.nextButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        // TODO: 로그인 성공 후, 기록탭 이동이 되지 않음.
        output.user.subscribe{
            // 기록탭으로 이동
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            guard let delegate = sceneDelegate else {
                return
            }
            delegate.window?.rootViewController = TabBarController()
        }
    }
    // MARK: - Functions
    // TextFields
    func initTextField() {
        appRegisterView.phoneTextField.delegate = self
        appRegisterView.codeTextField.delegate = self
    }
    // Buttons
    func initButton() {
        // 인증번호가 오지 않나요?
        appRegisterView.notSendedButton.rx.tap
            .bind {LinkManager(self, .codeError)}
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc func nextButtonDidTap() {
        if isUser && inputCode.value == self.authCode {
            // 이미 유저임을 확인했을 때 - 로그인 후 기록탭으로 이동
//            signIn()
        } else if !isUser && inputCode.value == self.authCode {
            // 회원가입 시
            let vc = TermsViewController()
            vc.phoneNum = self.phone.value
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // 전송된 인증코드와 입력된 인증코드가 다를 때
            self.appRegisterView.errorMessageLabel.isHidden = false
            print("보내진 인증코드와 입력한 코드번호가 맞지 않습니다.")
        }
    }
    @objc func goBack() {
        self.dismiss(animated: false)
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
////MARK: - API
//extension AppRegisterViewController {
//    private func sendSMS(){
//        let sendSMSRequestModel = PhoneNumRequestModel(phoneNum: self.phone.value)
//        UserService.shared.sendSMS(requestValue: sendSMSRequestModel) { result in
//            switch result {
//                case .success(let data):
//                    print("인증번호 전송 성공")
//                    guard let authCode = data.data?.value else {return}
//                    self.authCode = authCode
//                    print("인증코드:", self.authCode)
//                    break
//                case .failure(let err):
//                    print(err.localizedDescription)
//                    break
//            default:
//                NetworkAlert.show(in: self){ [weak self] in
//                    self?.sendSMS()
//                }
//                break
//            }
//        }
//    }
//    private func checkUser(){
//        let checkUserRequestModel = PhoneNumRequestModel(phoneNum: self.phone.value)
//        UserService.shared.checkUser(model: checkUserRequestModel) { result in
//            switch result {
//                case .success(let data):
//                    guard let isUser = data.data else {return}
//                    self.isUser = isUser
//                    print("유저 확인:", isUser)
//                    break
//                case .failure(let err):
//                    print(err.localizedDescription)
//                    break
//            default:
//                NetworkAlert.show(in: self){ [weak self] in
//                    self?.checkUser()
//                }
//                break
//            }
//        }
//    }
//    private func signIn(){
//        let signInRequestModel = SignInRequestModel(phoneNum: self.phone.value)
//        UserService.shared.signIn(requestValue: signInRequestModel) { result in
//            switch result {
//            case .success(let data):
//                // 유저 정보 저장
//                let token = data.accessToken ?? ""
//                let userId = data.userId ?? ""
//                let nickName = data.nickName ?? ""
//                let profileImg = data.imageURL ?? ""
//
//                UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
//                UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
//                UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
//                UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
//                // 자동 로그인을 위해 phoneNum과 token을 기기에 저장
//                UserDefaults.standard.set(self.phone.value, forKey: UserDefaultKey.phoneNum)
//
//                // 기록탭으로 이동
//                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//                guard let delegate = sceneDelegate else {
//                    return
//                }
//                delegate.window?.rootViewController = TabBarController()
//                break
//            default:
//                break
//            }
//        }
//    }
//}
