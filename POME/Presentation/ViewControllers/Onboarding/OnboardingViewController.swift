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
        UserService.shared.signIn(model: signInRequestModel) { result in
            switch result {
                case .success(let data):
                print(data)
                    if data.success! {
                        print("로그인 성공")
                        // 기록탭으로 이동
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                        // 유저 정보 저장
                        let token = data.data?.accessToken ?? ""
                        let userId = data.data?.userId ?? ""
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(userId, forKey: "userId")
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
