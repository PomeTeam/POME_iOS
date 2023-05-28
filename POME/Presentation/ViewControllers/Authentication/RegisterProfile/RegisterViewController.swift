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
import Foundation
import Alamofire

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var registerView: RegisterView!
    private let viewModel = RegisterProfileViewModel()
    let disposeBag = DisposeBag()
    
    // Image
    let imagePickerController = UIImagePickerController()
    // Phone Number
    var phoneNum: String = ""
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        initialize()
        bind()
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
    
    @discardableResult
    func bind() {
        let input = RegisterProfileViewModel.Input(nicknameTextField: registerView.nameTextField.rx.text.orEmpty.asObservable(),
                                                   phoneNum: Observable<String>.of(phoneNum),
                                                   ctaButtonTap: registerView.completeButton.rx.tap)
        let output = viewModel.transform(input)
        
        // 다음 버튼 활성화 유무
        output.ctaButtonActivate
            .drive(registerView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        // 닉네임 실시간 체크 후 메세지 출력
        output.ctaButtonActivate
            .drive {
                self.registerView.messageLabel.isHidden = false
                self.registerView.messageLabel.textColor = $0 ? Color.mint100 : Color.red
            }.disposed(by: disposeBag)
        
        output.message
            .bind(to: registerView.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 입력한 이름 Input 공백 제거
        output.nickname
            .bind(to: registerView.nameTextField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        // 프로필 이미지 선택 후 ImageView 출력
        output.photo.skip(1)
            .bind(to: registerView.profileImage.rx.image)
            .disposed(by: disposeBag)
        
        // 이미지 없이 회원가입
        output.signUp
            .bind{ _ in
                self.moveToRegisterCompletePage()
            }.disposed(by: disposeBag)
        
        // 이미지와 함께 회원가입
        output.signUpWithPhoto
            .bind { _ in
                self.moveToRegisterCompletePage()
            }.disposed(by: disposeBag)
        
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
        // delegate
        registerView.nameTextField.delegate = self
        imagePickerController.delegate = self
        
        initButton()
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
    }
    // 회원가입 완료 후 이동
    func moveToRegisterCompletePage() {
        let vc = CompleteRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    @objc func albumButtonDidTap() {
        viewModel.photoRelay.value == nil ? showCameraAndAlbumAlert() : showAlbumAlert()
    }
    
    // MARK: - Functions
    // 카메라 & 앨범 Alert창
    func showCameraAndAlbumAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title: "카메라", style: UIAlertAction.Style.default){(_) in
            // 카메라
            let camera = UIImagePickerController().then{
                $0.sourceType = .camera
                $0.allowsEditing = true
                $0.cameraDevice = .rear
                $0.cameraCaptureMode = .photo
                $0.delegate = self
            }
            
            self.present(camera, animated: true, completion: nil)
        }
        let albumAction =  UIAlertAction(title: "사진 앨범", style: UIAlertAction.Style.default){(_) in
            let album = UIImagePickerController().then{
                $0.delegate = self
                $0.sourceType = .photoLibrary
            }
            
            self.present(album, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    // 앨범 Alert창
    func showAlbumAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            // 프로필 이미지 삭제하기
            self.viewModel.uploadSelectedPhoto(Observable<UIImage?>.of(nil))
            self.registerView.profileImage.image = Image.photoDefault
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
// MARK: - ImagePicker Delegate
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 앨범에서 사진 선택 시
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.uploadSelectedPhoto(Observable<UIImage?>.of(image))
        }
        // 카메라에서 사진 찍은 경우
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            viewModel.uploadSelectedPhoto(Observable<UIImage?>.of(image))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
