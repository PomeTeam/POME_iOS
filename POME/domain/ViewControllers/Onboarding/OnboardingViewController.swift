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

        print("load")
        layout()
        initialize()
    }

    func layout() {
        print("layout")
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
        let vc = AppRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
