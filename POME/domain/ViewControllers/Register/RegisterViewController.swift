//
//  RegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var registerView: RegisterView!
    let maskView = UIImageView()
    let imagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage!
    var name: String!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        initialize()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maskView.frame = registerView.profileImage.bounds
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Methods
    func layout() {
        registerView = RegisterView()
        self.view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    func initialize() {
        maskView.image = Image.photoDefault
        registerView.profileImage.mask = maskView
        // imagePicker delegate
        imagePickerController.delegate = self
        
        registerView.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        registerView.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged), for: .editingChanged)
        
        registerView.profileButton.addTarget(self, action: #selector(albumButtonnDidTap), for: .touchUpInside)
        registerView.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.albumButtonnDidTap)))
    }

    @objc func completeButtonDidTap() {
        print("click!")
    }
    @objc func albumButtonnDidTap() {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc func nameTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.name = text
        checkValidName(self.name)
    }
    func checkValidName(_ name: String) {
        if name.count > 0 {
            registerView.messageLabel.then{
                $0.text = "멋진 닉네임이네요!"
                $0.textColor = Color.main
            }
            registerView.completeButton.isActivate(true)
        } else {
            registerView.messageLabel.then{
                $0.text = "사용할 수 없는 닉네임이에요"
                $0.textColor = Color.red
            }
            registerView.completeButton.isActivate(false)
        }
        registerView.messageLabel.isHidden = false
    }
}
// MARK: - ImagePicker Delegate
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedPhoto = UIImage()
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedPhoto = image
            self.registerView.profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
