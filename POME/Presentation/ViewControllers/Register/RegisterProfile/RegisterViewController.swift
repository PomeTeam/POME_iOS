//
//  RegisterViewController.swift
//  POME
//
//  Created by gomin on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var registerView: RegisterView!
    let maskView = UIImageView()
    
    // Image
    let imagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage!
    var fileKey: String = ""
    var presignedURL: String = ""
    var imageKey: String = ""
    
    var phoneNum : String = ""
    
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
        // textField.rx.text의 변경이 있을 때
        self.registerView.nameTextField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .map({ name in
                        return self.setValidName(name)
                    })
                    .bind(to: self.name)
                    .disposed(by: disposeBag)
                
        self.name.skip(1).distinctUntilChanged()
            .subscribe( onNext: { newValue in
                self.checkNickName(newValue)
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
//    func checkValidName(_ name: String) {
//        if name.count > 0 && name.count <= 10 {
//            registerView.messageLabel.then{
//                $0.text = "멋진 닉네임이네요!"
//                $0.textColor = Color.mint100
//            }
//            registerView.completeButton.isActivate(true)
//        } else {
//            registerView.messageLabel.then{
//                $0.text = "사용할 수 없는 닉네임이에요"
//                $0.textColor = Color.red
//            }
//            registerView.completeButton.isActivate(false)
//        }
//        registerView.messageLabel.isHidden = false
//    }
    // MARK: - Actions
    @objc func completeButtonDidTap() {
        if self.selectedPhoto != nil {
            getPresignedURL()
        } else {
            self.imageKey = "default"
            signUp()
        }
        
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
        // imageKey - 날짜 형식
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        fileKey += dateFormat.string(from: Date())
        fileKey += String(Int64(Date().timeIntervalSince1970)) + "_"
        fileKey += UUID().uuidString
        print(fileKey)
        
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: - API
extension RegisterViewController {
    // 닉네임 중복 체크 (실시간)
    private func checkNickName(_ nickname: String) {
        let checkNicknameRequestModel = CheckNicknameRequestModel(nickName: nickname)
        UserService.shared.checkNickName(model: checkNicknameRequestModel) { result in
            switch result {
                case .success(let data):
                    self.registerView.messageLabel.isHidden = false
                    if let isValidName = data.data {
                        if isValidName {
                            self.registerView.messageLabel.then{
                                $0.text = data.message!
                                $0.textColor = Color.mint100
                            }
                            self.registerView.completeButton.isActivate(true)
                        } else {
                            self.registerView.messageLabel.then{
                                $0.text = data.message!
                                $0.textColor = Color.red
                            }
                            self.registerView.completeButton.isActivate(false)
                        }
                    } else {
                        self.registerView.messageLabel.then{
                            $0.text = data.message!
                            $0.textColor = Color.red
                        }
                        self.registerView.completeButton.isActivate(false)
                    }
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
            default:
                break
            }
        }
    }
    
    // presignedURL 받기 -> 이미지 서버에 저장 -> 회원가입
    private func getPresignedURL(){
        let id = self.fileKey
        UserService.shared.getPresignedURL(id: id) { result in
            switch result {
                case .success(let data):
                    print("presignedURL 요청 성공", data.id)
                    self.imageKey = data.id
                    self.presignedURL = data.presignedUrl
//                    print(self.presignedURL)
                
                    self.putImageToSerVer()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
            default:
                break
            }
        }
    }
    // 이미지 서버에 저장
    private func putImageToSerVer() {
        UserService.shared.putImageToServer(preUrl: self.presignedURL, image: self.selectedPhoto) { result in
            switch result{
            case .success(let data):
                print("서버에 이미지 저장 성공")
                self.signUp()
                
                break
            default:
                break
            }
        }
    }
    // 회원가입
    private func signUp() {
        let signUpRequestModel = SignUpRequestModel(nickname: self.name.value, phoneNum: self.phoneNum, imageKey: self.imageKey)
        UserService.shared.signUp(model: signUpRequestModel) { result in
            switch result {
                case .success(let data):
                    print(data)
                
                    if data.success! {
                        print("회원가입 성공")
                        
                        // 유저 정보 저장
                        let token = data.data?.accessToken ?? ""
                        let userId = data.data?.userId ?? ""
                        let nickName = data.data?.nickName ?? ""
                        let profileImg = data.data?.imageURL ?? ""
                        
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(userId, forKey: "userId")
                        UserDefaults.standard.set(nickName, forKey: "nickName")
                        UserDefaults.standard.set(profileImg, forKey: "profileImg")
                        UserDefaults.standard.set(self.phoneNum, forKey: "phoneNum")
                        
                        let vc = CompleteRegisterViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    break
                
                case .failure(let err):
                    print(err.localizedDescription)
                    break
            default:
                break
            }
        }
    }
}
