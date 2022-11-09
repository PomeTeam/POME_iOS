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
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
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
        registerView.nameTextField.delegate = self
        
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
// MARK: - TextField & Keyboard Methods
extension RegisterViewController: UITextFieldDelegate {
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height + 10
            let viewHeight = Const.Device.HEIGHT - self.registerView.messageLabel.frame.origin.y
            print(keyboardHeight, viewHeight)
            if viewHeight < keyboardHeight {
                let dif = keyboardHeight - viewHeight
                self.view.frame.origin.y -= (dif + 20)
            }
        }
        print("keyboard Will appear Execute")
    }
    
    @objc func keyboardWillDisappear(noti: NSNotification) {
        if self.view.frame.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
            print("keyboard Will Disappear Execute")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn Execute")
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing Execute")
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
    
}
