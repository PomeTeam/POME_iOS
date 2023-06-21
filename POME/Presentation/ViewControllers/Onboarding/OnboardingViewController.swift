//
//  OnBoardingViewController.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    var onboardingView: OnboardingView!
    private let viewModel = OnboardingViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    func layout() {
        onboardingView = OnboardingView()
        self.view.addSubview(onboardingView)
        onboardingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        let input = OnboardingViewModel.Input(ctaButtonControlEvent: onboardingView.startButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        // 토큰 부재 -> 로그인 페이지 이동
        output.rememberMeDriver
            .drive {
                if !$0 {self.moveToLogin()}
            }
        
        // 토큰 존재 -> 로그인 후 기록탭 이동
        output.user.bind { _ in
            self.moveToRecordTab()
        }.disposed(by: disposeBag)
        
    }
    
    func moveToLogin() {
        // 회원가입 창으로 이동
        let vc = SignInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToRecordTab() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            // 에러 알림
            return
        }
        delegate.window?.rootViewController = TabBarController()
    }
    
}
