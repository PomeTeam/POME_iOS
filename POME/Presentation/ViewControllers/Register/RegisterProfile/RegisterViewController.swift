//
//  RegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var registerView: RegisterView!
    let maskView = UIImageView()
    
    let imagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    let name =  BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        initialize()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    // MARK: - Methods
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    func layout() {
        registerView = RegisterView()
        self.view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    func initialize() {
        registerView.nameTextField.delegate = self
        
        // imagePicker delegate
        imagePickerController.delegate = self
        
        initButton()
        initNameTextField()
    }
    
    func initButton() {
        let albumTapGesture = UITapGestureRecognizer()
        registerView.profileImage.addGestureRecognizer(albumTapGesture)
        albumTapGesture.rx.event.bind(onNext: { recognizer in
            self.albumButtonDidTap()
        }).disposed(by: disposeBag)
        registerView.profileButton.rx.tap
            .bind {self.albumButtonDidTap()}
            .disposed(by: disposeBag)
        registerView.completeButton.rx.tap
            .bind {self.completeButtonDidTap()}
            .disposed(by: disposeBag)
    }
    func initNameTextField() {
        // textField.rx.text??? ????????? ?????? ???
        self.registerView.nameTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .map({ name in
                        return self.setValidName(name)
                    })
                    .bind(to: self.name)
                    .disposed(by: disposeBag)
                
        self.name.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.checkValidName(newValue)
//            print("name changed : \(newValue) ")
            })
            .disposed(by: disposeBag)
    }
    func setValidName(_ nameStr: String) -> String {
        var currName = nameStr
        if nameStr.count <= 10 {
            currName = nameStr.filter {!($0.isWhitespace)}
        } else {
            currName = self.name.value
            self.view.endEditing(true)
        }
        self.registerView.nameTextField.text = currName
        return currName
    }
    func checkValidName(_ name: String) {
        if name.count > 0 && name.count <= 10 {
            registerView.messageLabel.then{
                $0.text = "?????? ??????????????????!"
                $0.textColor = Color.mint100
            }
            registerView.completeButton.isActivate(true)
        } else {
            registerView.messageLabel.then{
                $0.text = "????????? ??? ?????? ??????????????????"
                $0.textColor = Color.red
            }
            registerView.completeButton.isActivate(false)
        }
        registerView.messageLabel.isHidden = false
    }
    // MARK: - Actions
    @objc func completeButtonDidTap() {
        let vc = CompleteRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func albumButtonDidTap() {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
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
