//
//  LoginViewModelTests.swift
//  MamiBank
//
//  Created by Hoil Sida on 12/11/25.
//
import XCTest
@testable import Mami_Dev

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockRepo: MockLoginRepository!
    
    override func setUp() {
        mockRepo = MockLoginRepository()
        viewModel = LoginViewModel(repo: mockRepo)
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoginSuccess() async throws {
        viewModel.login(phone: "012345678", password: "123@123")
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        switch viewModel.state {
        case .success(let model):
            XCTAssertEqual(model.token, "token-mock")
        default:
            XCTFail("Should be success")
        }
        
    }
    
    func testLoginError() async {
        mockRepo.shouldReturnError = true
        viewModel.login(phone: "012345678", password: "123@123")
        try? await Task.sleep(nanoseconds: 200_000_000)
        
//        switch viewModel.state{
//        case .failure(let msg):
//            XCTAssertTrue(msg.count > 0)
//        default:
//            XCTFail("Expected error")
//        }
        
    }
}
