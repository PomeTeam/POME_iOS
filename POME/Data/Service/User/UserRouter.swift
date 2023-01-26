//
//  UserRouter.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya
import UIKit

enum UserRouter: BaseRouter{
    case signUp(param: SignUpRequestModel)
    case signIn(param: SignInRequestModel)
    case sendSMS(param: SendSMSRequestModel)
    
    case imageServer(id: String)
    case putImageToServer(preUrl: String, image: UIImage)
}

extension UserRouter{
    
    var baseURL: URL {
        switch self {
        case .imageServer:
            return URL(string: "http://image-main-server.ap-northeast-2.elasticbeanstalk.com/presigned-url")!
        case .putImageToServer(let preUrl, _):
            return URL(string: preUrl)!
        default:
            let url = Bundle.main.infoDictionary?["API_URL"] as? String ?? ""
            return URL(string: "http://" + url)!
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return HTTPMethodURL.POST.signUp
        case .signIn:
            return HTTPMethodURL.POST.signIn
        case .sendSMS:
            return HTTPMethodURL.POST.sms
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .signIn:
            return .post
        case .sendSMS:
            return .post
        case .imageServer:
            return .get
        case .putImageToServer:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let param):
            return .requestJSONEncodable(param)
        case .signIn(let param):
            return .requestJSONEncodable(param)
        case .sendSMS(let param):
            return .requestJSONEncodable(param)
        case .imageServer(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .putImageToServer(_, let image):
            if let image = image.jpegData(compressionQuality: 1.0) {
                return .uploadMultipart([MultipartFormData(provider: .data(image), name: "image", fileName: "background.jpg", mimeType: "image/jpg")])
            }
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .putImageToServer:
            return ["Content-Type" : "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
