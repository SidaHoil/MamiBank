//
//  MockLoginRepository.swift
//  MamiBank
//
//  Created by Hoil Sida on 17/11/25.
//
import Foundation
import Combine
@testable import Mami_Dev

class MockLoginRepository: LoginRepositoryProtocol {
    
    var shouldReturnError = false
    var loginResult: LoginResponseModel = LoginResponseModel(status: "success", message: "OK", token: "token-mock")
    
    func login(phone: String, password: String) async throws -> LoginResponseModel {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: 999)
        }
        return loginResult
    }
}
