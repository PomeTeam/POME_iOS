//
//  RegisterProfileViewModel.swift
//  POME
//
//  Created by gomin on 2023/05/29.
//

import Foundation
import RxSwift
import RxCocoa


class RegisterProfileViewModel: BaseViewModel {
    // UseCase Properties
    private let checkNicknameUseCase: CheckNicknameUseCaseInterface
    private let signUpUseCase: SignUpUseCaseInterface
    private let presignedURLUseCase: PresignedURLUseCaseInterface
    
    // UserData Properties
    var nicknameRelay = BehaviorRelay<String?>(value:nil)
    var phoneRelay = BehaviorRelay<String?>(value:nil)
    
    // Photo Properties
    var photoRelay = BehaviorRelay<UIImage?>(value:nil)
    var photoFileKey = BehaviorRelay<String?>(value:nil)
    var photoImageKey = BehaviorRelay<String>(value:"default")
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        let nicknameTextField: Observable<String>
        let phoneNum: Observable<String>
        let ctaButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let ctaButtonActivate: Driver<Bool>
        let nickname: Observable<String>
        let message: Observable<String>
        let photo: BehaviorRelay<UIImage?>
        let signUp: Observable<UserModel>
        let signUpWithPhoto: Observable<UserModel>
    }
    
    init(checkNicknameUseCase: CheckNicknameUseCaseInterface = CheckNicknameUseCase(),
         signUpUseCase: SignUpUseCaseInterface = SignUpUseCase(),
         presignedURLUseCase: PresignedURLUseCaseInterface = PresignedURLUseCase()) {
        self.checkNicknameUseCase = checkNicknameUseCase
        self.signUpUseCase = signUpUseCase
        self.presignedURLUseCase = presignedURLUseCase
    }
    
    @discardableResult
    func transform(_ input: Input) -> Output{
        
        let nickname = input.nicknameTextField.skip(1)
            .map{
                self.setValidName($0 ?? "")
            }
            .asObservable()
            .share()
        
        input.phoneNum.bind(to: phoneRelay).disposed(by: disposeBag)
        
        _ = nickname.bind(to: nicknameRelay).disposed(by: disposeBag)
        
        // Nickname Check
        let checkNicknameResponse = nickname
            .skip(1)
            .map {
                CheckNicknameRequestModel(nickName: $0)
            }.flatMap {
                self.checkNicknameUseCase.execute(requestValue: $0)
            }.share()
        
        // message
        let checkNicknameMessage = checkNicknameResponse.map {$0.message}
        
        // is valid nickname
        let validNickname = checkNicknameResponse
            .map {$0.data ?? false}
            .asDriver(onErrorJustReturn: false)
        
        // Get Presigned URL (with Photo)
        let presignedURLResponse = input.ctaButtonTap
            .filter{self.photoRelay.value != nil}
            .do{
                self.generateFileKey()
            }
            .flatMap {
                self.presignedURLUseCase.execute(id: self.photoFileKey.value ?? "")
            }.share()
        
        let imageKey = presignedURLResponse
            .map {$0.id}
            .bind(to: self.photoImageKey)
            .disposed(by: disposeBag)
        
        // Put To Image Server & Sign Up
        let putImgServerResponse = presignedURLResponse
            .do {
                self.presignedURLUseCase.saveToImgServer(url: $0.presignedUrl,
                                                         image: self.photoRelay.value ?? UIImage())
            }.map { _ in
                SignUpRequestModel(nickname: self.nicknameRelay.value ?? "",
                                   phoneNum: self.phoneRelay.value ?? "",
                                   imageKey: self.photoImageKey.value)
            }.flatMap {
                self.signUpUseCase.execute(requestValue: $0)
            }.do{
                self.saveUserData($0)
            }.share()
        
        
        // Sign Up (without Photo)
        let signUpResponse = input.ctaButtonTap
            .filter{self.photoRelay.value == nil}
            .map { [self] in
                SignUpRequestModel(nickname: self.nicknameRelay.value ?? "",
                                   phoneNum: self.phoneRelay.value ?? "",
                                   imageKey: self.photoImageKey.value)
            }.flatMap {
                self.signUpUseCase.execute(requestValue: $0)
            }.do{
                self.saveUserData($0)
            }.share()
        
        
        
        return Output(ctaButtonActivate: validNickname,
                      nickname: nickname,
                      message: checkNicknameMessage,
                      photo: photoRelay,
                      signUp: signUpResponse,
                      signUpWithPhoto: putImgServerResponse)
    }
    
    // MARK: Methods
    // 닉네임 Input 양쪽 공백 제거
    func setValidName(_ nameStr: String) -> String {
        return nameStr.count <= 10 ? nameStr.filter{!($0.isWhitespace)} : self.nicknameRelay.value ?? ""
    }
    
    // VC > 앨범에서 사진 선택 시 호출
    func uploadSelectedPhoto(_ image: Observable<UIImage?>) {
        image.bind(to: photoRelay).disposed(by: disposeBag)
    }
    
    // fileKey 생성
    func generateFileKey(){
        var fileKey: String = ""
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        
        fileKey += dateFormat.string(from: Date())
        fileKey += String(Int64(Date().timeIntervalSince1970)) + "_"
        fileKey += UUID().uuidString
        
        _ = Observable<String>.of(fileKey)
            .bind(to: photoFileKey)
            .disposed(by: disposeBag)
    }
    
    // 유저 정보 저장
    func saveUserData(_ user: UserModel) {
        let token = user.accessToken ?? ""
        let userId = user.userId ?? ""
        let nickName = user.nickName ?? ""
        let profileImg = user.imageURL ?? ""
        
        UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
        UserDefaults.standard.set(userId, forKey: UserDefaultKey.userId)
        UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName)
        UserDefaults.standard.set(profileImg, forKey: UserDefaultKey.profileImg)
        UserDefaults.standard.set(phoneRelay.value, forKey: UserDefaultKey.phoneNum)
    }
    
}
