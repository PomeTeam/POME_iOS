//
//  TermsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class TermsViewController: UIViewController {
    var termsView: TermsView!

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
        let useTermTap = UITapGestureRecognizer(target: self, action: #selector(termDetailButtonDidTap))
        termsView.useTermLabel.addGestureRecognizer(useTermTap)
        let privTermTap = UITapGestureRecognizer(target: self, action: #selector(termDetailButtonDidTap))
        termsView.privacyTermLabel.addGestureRecognizer(privTermTap)
        let markTermTap = UITapGestureRecognizer(target: self, action: #selector(termDetailButtonDidTap))
        termsView.marketingTermLabel.addGestureRecognizer(markTermTap)
        
        termsView.allAgreeCheck.addTarget(self, action: #selector(allAgreeButtonDidTap), for: .touchUpInside)
        termsView.useTermCheck.addTarget(self, action: #selector(useTermCheckDidTap), for: .touchUpInside)
        termsView.privacyTermCheck.addTarget(self, action: #selector(privacyTermCheckDidTap), for: .touchUpInside)
        termsView.marketingTermCheck.addTarget(self, action: #selector(marketingTermCheckDidTap), for: .touchUpInside)
    }
    
    @objc func termDetailButtonDidTap(sender: UITapGestureRecognizer) {
//        print("ckick")
//        self.navigationController?.pushViewController(TermsViewController(), animated: true)
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
    }
    @objc func useTermCheckDidTap() {
        let button = termsView.useTermCheck
        button.isSelected.toggle()
    }
    @objc func privacyTermCheckDidTap() {
        let button = termsView.privacyTermCheck
        button.isSelected.toggle()
    }
    @objc func marketingTermCheckDidTap() {
        let button = termsView.marketingTermCheck
        button.isSelected.toggle()
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

