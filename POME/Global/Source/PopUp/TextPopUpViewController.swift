//
//  TextPopUpViewController.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class TextPopUpViewController: UIViewController {
    // MARK: - Properties
    private var titleText: String?
    private var greenBtnText: String?
    private var grayBtnText: String?
    
    let popupView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    let titleLabel = UILabel().then{
        $0.text = "title"
        $0.textColor = Color.title
    }
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    // MARK: - Life Cycles
    convenience init(titleText: String? = nil,
                     greenBtnText: String? = nil,
                     grayBtnText: String? = nil) {
        self.init()

        self.titleText = titleText
        self.greenBtnText = greenBtnText
        self.grayBtnText = grayBtnText
        
        setUpContent()
        setUpView()
        setUpConstraint()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.popUpBackground

        cancelBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = true
        }
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: false)
    }
    // MARK: - Functions
    func setUpContent() {
        titleLabel.text = self.titleText
        titleLabel.setTypoStyleWithSingleLine(typoStyle: .title3)
        titleLabel.textAlignment = .center
        
        cancelBtn = DefaultButton(titleStr: self.grayBtnText ?? "", typo: .title3, backgroundColor: Color.grey1, titleColor: Color.grey5)
        okBtn = DefaultButton(titleStr: self.greenBtnText ?? "")
    }
    func setUpView() {
        self.view.addSubview(popupView)
        
        popupView.addSubview(titleLabel)
        popupView.addSubview(cancelBtn)
        popupView.addSubview(okBtn)
    }
    func setUpConstraint() {
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(42)
            make.height.greaterThanOrEqualTo(128)
            make.centerY.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(124.5)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        okBtn.snp.makeConstraints { make in
            make.width.equalTo(124.5)
            make.height.equalTo(38)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(cancelBtn)
            make.top.equalTo(cancelBtn)
        }
    }
}
