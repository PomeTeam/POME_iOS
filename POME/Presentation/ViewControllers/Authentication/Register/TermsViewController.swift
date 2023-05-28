//
//  TermsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class TermsViewController: UIViewController {
    var termsView: TermsView!
    var phoneNum : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        initialize()
    }
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    func layout() {
        termsView = TermsView()
        self.view.addSubview(termsView)
        termsView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    func initialize() {
        let useTermTap = UITapGestureRecognizer(target: self, action: #selector(userTermButtonDidTap))
        termsView.useTermLabel.addGestureRecognizer(useTermTap)
        let privTermTap = UITapGestureRecognizer(target: self, action: #selector(privTermButtonDidTap))
        termsView.privacyTermLabel.addGestureRecognizer(privTermTap)
        let markTermTap = UITapGestureRecognizer(target: self, action: #selector(markTermButtonDidTap))
        termsView.marketingTermLabel.addGestureRecognizer(markTermTap)
        
        termsView.allAgreeCheck.addTarget(self, action: #selector(allAgreeButtonDidTap), for: .touchUpInside)
        termsView.useTermCheck.addTarget(self, action: #selector(useTermCheckDidTap), for: .touchUpInside)
        termsView.privacyTermCheck.addTarget(self, action: #selector(privacyTermCheckDidTap), for: .touchUpInside)
        termsView.marketingTermCheck.addTarget(self, action: #selector(marketingTermCheckDidTap), for: .touchUpInside)
        
        termsView.agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
    }
    func isValidCheck() {
        let isValid = termsView.useTermCheck.isSelected && termsView.privacyTermCheck.isSelected
        termsView.agreeButton.isActivate(isValid)
        
        termsView.allAgreeCheck.isSelected = termsView.useTermCheck.isSelected && termsView.privacyTermCheck.isSelected && termsView.marketingTermCheck.isSelected ? true : false
    }
    
    // MARK: - Actions
    @objc func agreeButtonDidTap() {
        let vc = RegisterViewController()
        vc.phoneNum = self.phoneNum
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func userTermButtonDidTap(sender: UITapGestureRecognizer) {
        LinkManager(self, .serviceUse)
    }
    @objc func privTermButtonDidTap(sender: UITapGestureRecognizer) {
        LinkManager(self, .privacyTerm)
    }
    @objc func markTermButtonDidTap(sender: UITapGestureRecognizer) {
        LinkManager(self, .marketingTerm)
    }
    @objc func allAgreeButtonDidTap() {
        if !termsView.allAgreeCheck.isSelected {
            termsView.allAgreeCheck.isSelected = true
            termsView.useTermCheck.isSelected = true
            termsView.privacyTermCheck.isSelected = true
            termsView.marketingTermCheck.isSelected = true
        } else {
            termsView.allAgreeCheck.isSelected = false
            termsView.useTermCheck.isSelected = false
            termsView.privacyTermCheck.isSelected = false
            termsView.marketingTermCheck.isSelected = false
        }
        isValidCheck()
    }
    @objc func useTermCheckDidTap() {
        let button = termsView.useTermCheck
        button.isSelected.toggle()
        isValidCheck()
    }
    @objc func privacyTermCheckDidTap() {
        let button = termsView.privacyTermCheck
        button.isSelected.toggle()
        isValidCheck()
    }
    @objc func marketingTermCheckDidTap() {
        let button = termsView.marketingTermCheck
        button.isSelected.toggle()
        isValidCheck()
    }
}
class TermCheckButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        
        self.setImage(Image.checkGrey, for: .normal)
        self.setImage(Image.checkGreen, for: .selected)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

