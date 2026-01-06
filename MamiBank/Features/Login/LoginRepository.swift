//
//  LoginRepository.swift
//  MamiBank
//
//  Created by Hoil Sida on 14/11/25.
//

import Foundation
import Moya

protocol LoginRepositoryProtocol: Sendable {
    func login(phone: String, password: String) async throws -> LoginResponseModel
}

struct LoginRepository: LoginRepositoryProtocol {
    private let provider: MoyaProvider<API>
    
    init(isMock: Bool = EnvironmentConfig.shared.isMock) {
        self.provider = isMock ? MoyaProvider<API>(stubClosure: { _ in .immediate }) : MoyaProvider<API>()
    }
    
    func login(phone: String, password: String) async throws -> LoginResponseModel {
        let response = try await provider.asyncRequest(.login(phone: phone, password: password))
        return try JSONDecoder().decode(LoginResponseModel.self, from: response.data)
    }
}
