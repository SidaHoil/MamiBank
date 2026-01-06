//
//  LoginUITest.swift
//  MamiBank
//
//  Created by Hoil Sida on 17/11/25.
//

import XCTest

final class LoginUITests: XCTestCase {
    
    func test_should_show_message_when_login_with_empty_input() {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        XCTAssertTrue(app.buttons["login_button"].exists)
    }
}
