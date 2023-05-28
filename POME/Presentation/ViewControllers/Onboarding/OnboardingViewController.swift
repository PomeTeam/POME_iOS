//
//  OnBoardingViewController.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import UIKit

class OnboardingViewController: UIViewController {
    var onboardingView: LoginView!

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    func layout() {
        onboardingView = LoginView()
        self.view.addSubview(onboardingView)
        onboardingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    func initialize() {
        
        onboardingView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    @objc func startButtonDidTap() {
        // 자동 로그인
        rememberMe()
    }
}
//MARK: - API
extension OnboardingViewController {
    private func rememberMe(){
        // token이 존재하면, 기기 내에 저장된 phoneNum을 가지고 로그인API 연결
        let token = UserManager.token ?? ""
        let phoneNum = UserManager.phoneNum ?? ""
        
        if token != "" && phoneNum != "" {
            signIn(phoneNum)
        } else {
            // 회원가입 창으로 이동
            let vc = AppRegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func signIn(_ phoneNum: String){
        let signInRequestModel = SignInRequestModel(phoneNum: phoneNum)
        UserService.shared.signIn(requestValue: signInRequestModel) { result in
            switch result {
                case .success(let data):
                print("로그인 성공")
                // 기록탭으로 이동
                
                // 유저 정보 저장
                let token = data.accessToken ?? ""
                let userId = data.userId ?? ""
                let nickName = data.nickName ?? ""
                let profileImg = data.imageURL ?? ""
                
                UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
                UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
                UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
                UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
                
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else {
                    // 에러 알림
                    return
                }
                delegate.window?.rootViewController = TabBarController()
                
                break
            default:
                NetworkAlert.show(in: self){ [weak self] in
                    self?.signIn(phoneNum)
                }
                break
            }
        }
    }

}
