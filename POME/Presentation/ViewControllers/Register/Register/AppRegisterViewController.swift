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
        
        // 인증번호가 오지 않나요?
        appRegisterView.notSendedButton.rx.tap
            .bind {LinkManager(self, .codeError)}
            .disposed(by: disposeBag)
        
        // 동의하고 시작하기 버튼
        appRegisterView.nextButton.rx.tap
            .bind {self.nextButtonDidTap()}
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc func codeSendButtonDidTap() {
        appRegisterView.codeSendButton.isSelected = true
        sendSMS()   // 문자 전송
        checkUser() // 유저 확인
    }
    @objc func nextButtonDidTap() {
        if isUser && inputCode.value == self.authCode {
            // 이미 유저임을 확인했을 때 - 로그인 후 기록탭으로 이동
            signIn()
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
//        var txtPop = TextInfoPopUpViewController(titleText: "문자 전송 API 호출", greenBtnText: "ok")
//        txtPop.modalPresentationStyle = .overFullScreen
//        self.present(txtPop, animated: false, completion: nil)
//        txtPop.okBtn.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        
        let sendSMSRequestModel = PhoneNumRequestModel(phoneNum: self.phone.value)
        UserService.shared.sendSMS(model: sendSMSRequestModel) { result in
            switch result {
                case .success(let data):
                    print("인증번호 전송 성공")
                    guard let authCode = data.data?.value else {return}
                    self.authCode = authCode
                    print("인증코드:", self.authCode)
                
                let txtPop = TextInfoPopUpViewController(titleText: "문자가 전송되었습니다.", greenBtnText: "ok")
                txtPop.modalPresentationStyle = .overFullScreen
                self.present(txtPop, animated: false, completion: nil)
                txtPop.okBtn.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
                
                    break
                case .failure(let err):
                let txtPop = TextInfoPopUpViewController(titleText: "문자 전송이 실패되었습니다.", greenBtnText: "ok")
                txtPop.modalPresentationStyle = .overFullScreen
                self.present(txtPop, animated: false, completion: nil)
                txtPop.okBtn.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
                
                    print(err.localizedDescription)
                    break
            default:
                NetworkAlert.show(in: self){ [weak self] in
                    self?.sendSMS()
                }
                break
            }
        }
    }
    private func checkUser(){
        let checkUserRequestModel = PhoneNumRequestModel(phoneNum: self.phone.value)
        UserService.shared.checkUser(model: checkUserRequestModel) { result in
            switch result {
                case .success(let data):
                    guard let isUser = data.data else {return}
                    self.isUser = isUser
                    print("유저 확인:", isUser)
                    
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
            default:
                break
            }
        }
    }
    private func signIn(){
        let signInRequestModel = SignInRequestModel(phoneNum: self.phone.value)
        UserService.shared.signIn(model: signInRequestModel) { result in
            switch result {
                case .success(let data):
                    if data.success {
                        // 기록탭으로 이동
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                        // 유저 정보 저장
                        let token = data.data?.accessToken ?? ""
                        let userId = data.data?.userId ?? ""
                        let nickName = data.data?.nickName ?? ""
                        let profileImg = data.data?.imageURL ?? ""
                        
                        UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
                        UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
                        UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
                        UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
                        // 자동 로그인을 위해 phoneNum과 token을 기기에 저장
                        UserDefaults.standard.set(self.phone.value, forKey: UserDefaultKey.phoneNum)
                    }
                    
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
