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
        // Token이 "Bearer ~ " 의 형태로 응답받고 저장됨.
        let token = UserManager.token ?? ""
        let header = [
            "Content-Type": "application/json",
            "ACCESS-TOKEN": token]
        return header
    }

    var sampleData: Data {
        return Data()
    }

}
