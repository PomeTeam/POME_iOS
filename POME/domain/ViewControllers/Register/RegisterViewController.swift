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
        
        initButton()
        initNameTextField()
    }
    
    func initButton() {
        registerView.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.albumButtonnDidTap)))
        registerView.profileButton.rx.tap
            .bind {self.albumButtonnDidTap()}
            .disposed(by: disposeBag)
        registerView.completeButton.rx.tap
            .bind {self.completeButtonDidTap()}
            .disposed(by: disposeBag)
    }
    func initNameTextField() {
        // editingChanged 이벤트가 발생 했을 때
        registerView.nameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
//                print("editingChanged : \(self.registerView.nameTextField.text ?? "")")
            }).disposed(by: disposeBag)
        
        // textField.rx.text의 변경이 있을 때
        self.registerView.nameTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .map { $0 as String }
                    .bind(to: self.name)
                    .disposed(by: disposeBag)
                
        self.name.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
//            print("name changed : \(newValue) ")
            self.checkValidName(newValue)
        }).disposed(by: disposeBag)
        
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
    // MARK: - Actions
    @objc func completeButtonDidTap() {
        print("click!")
    }
    @objc func albumButtonnDidTap() {
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
