//
//  OnBoardingViewController.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import UIKit

class OnboardingViewController: UIViewController {
    var onboardingView: OnboardingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        initialize()
    }

    func layout() {
        onboardingView = OnboardingView()
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
        let vc = OnboardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
