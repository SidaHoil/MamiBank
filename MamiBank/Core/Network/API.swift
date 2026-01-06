//
//  API.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import Foundation
import Moya
internal import Alamofire

enum API {
    case register
    case login(phone: String, password: String)
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL(string: EnvironmentConfig.shared.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let phone, let password):
            let param = ["phone": phone, "password": password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .register:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return MockDataLoader.load("LoginMockResponse")
        case .register:
            return Data()
        }
    }
}
