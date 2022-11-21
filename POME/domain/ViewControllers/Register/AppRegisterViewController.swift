//
//  AppRegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/20.
//

import UIKit

class AppRegisterViewController: BaseViewController {
    var appRegisterView: AppRegisterView!

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
        // TextField
        appRegisterView.nameTextField.delegate = self
        appRegisterView.phoneTextField.delegate = self
        appRegisterView.codeTextField.delegate = self
        
        // Button
        appRegisterView.codeSendButton.addTarget(self, action: #selector(codeSendButtonDidTap), for: .touchUpInside)
    }
    @objc func codeSendButtonDidTap() {
        appRegisterView.codeSendButton.isSelected = true
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
