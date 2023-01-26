//
//  BaseTargetType.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation
import Moya

protocol BaseRouter: Moya.TargetType {
}

extension BaseRouter {

    var baseURL: URL {
        let url = Bundle.main.infoDictionary?["API_URL"] as? String ?? ""
        return URL(string: "http://" + url)!
    }

    var headers: [String: String]? {
        let token = UserManager.token ?? ""
        let header = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token]
        return header
    }

    var sampleData: Data {
        return Data()
    }

}
