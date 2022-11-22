//
//  PopUpViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

// Default 팝업창
class ImagePopUpViewController: UIViewController {
    // MARK: - Properties
    private var imageValue: UIImage?
    private var titleText: String?
    private var messageText: String?
    private var greenBtnText: String?
    private var grayBtnText: String?
    
    let popupView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    let popupImage = UIImageView()
    let titleLabel = UILabel().then{
        $0.text = "title"
        $0.textColor = Color.title
    }
    let messageLabel = UILabel().then{
        $0.text = "message"
        $0.textColor = Color.grey5
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    // MARK: - Life Cycles
    convenience init(_ imageValue: UIImage? = nil,
                     _ titleText: String? = nil,
                     _ messageText: String? = nil,
                     _ greenBtnText: String? = nil,
                     _ grayBtnText: String? = nil) {
        self.init()

        self.imageValue = imageValue
        self.titleText = titleText
        self.messageText = messageText
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
        popupImage.image = self.imageValue
        titleLabel.text = self.titleText
        titleLabel.setTypoStyleWithSingleLine(typoStyle: .title3)
        titleLabel.textAlignment = .center
        
        messageLabel.text = self.messageText
        messageLabel.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        messageLabel.textAlignment = .center
        
        cancelBtn = DefaultButton(titleStr: self.grayBtnText ?? "", typo: .title3, backgroundColor: Color.grey1, titleColor: Color.grey5)
        okBtn = DefaultButton(titleStr: self.greenBtnText ?? "")
    }
    func setUpView() {
        self.view.addSubview(popupView)
        
        popupView.addSubview(popupImage)
        popupView.addSubview(titleLabel)
        popupView.addSubview(messageLabel)
        popupView.addSubview(cancelBtn)
        popupView.addSubview(okBtn)
    }
    func setUpConstraint() {
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(148)
            make.centerY.centerX.equalToSuperview()
        }
        popupImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(popupImage.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
//            make.bottom.equalTo(horizontalSeperator.snp.top).offset(-32)
        }
        cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(142.5)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
        }
        okBtn.snp.makeConstraints { make in
            make.width.equalTo(142.5)
            make.height.equalTo(38)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(cancelBtn)
            make.top.equalTo(cancelBtn)
        }
    }
}
