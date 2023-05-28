//
//  UserRepositoryInterface.swift
//  POME
//
//  Created by gomin on 2023/05/27.
//

import Foundation
import RxSwift

protocol UserRepositoryInterface{
    func sendCode(requestValue: PhoneNumRequestModel) -> Observable<SendSMSResponseModel>
    func checkUser(requestValue: PhoneNumRequestModel) -> Observable<Bool>
    func signIn(requestValue: SignInRequestModel) -> Observable<UserModel>
    func signUp(requestValue: SignUpRequestModel) -> Observable<UserModel>
    func checkNickname(requestValue: CheckNicknameRequestModel) -> Observable<BaseResponseModel<Bool>>
    func getPresignedURL(id: String) -> Observable<PresignedURLResponseModel>
    func putImgServer(url: String, image: UIImage)
}
