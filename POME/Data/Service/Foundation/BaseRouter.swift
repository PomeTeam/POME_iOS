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
            "ACCESS-TOKEN": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBY2Nlc3MtSGVhZGVyIiwiaWF0IjoxNjc0ODA1MjI1LCJ1c2VySWQiOiJlZTFkYWQ2NS1jNmQzLTRiZmUtODlkNS00MjBmYWI5MDRjMjYiLCJuaWNrbmFtZSI6InRldGV0ZXRlIiwiZXhwIjoxNjc0ODA2NDI1fQ._3WYOKSA0_XgeR15de4Et4NYVt4mv8C0-zMwzbg1fjc"]
        return header
    }

    var sampleData: Data {
        return Data()
    }

}
