//
//  ProfileRegisterFlowUITests.swift
//  POMEUITests
//
//  Created by gomin on 2022/12/01.
//

import XCTest

class AppLoginFlowUITests: XCTestCase {
    
    private var app:XCUIApplication!
    private var phoneTF:XCUIElement!
    private var codeTF:XCUIElement!
    private var sendCodeBtn:XCUIElement!
    private var nextBtn:XCUIElement!
    
    private var touchScreen:XCUIElement!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()
        
        // '시작하기' 클릭
        app.buttons["시작하기"].tap()
        
        // Login Data input
        phoneTF = app.textFields["- 없이 숫자만 입력해주세요"]
        codeTF = app.textFields["인증번호를 입력해주세요"]
        sendCodeBtn = app.buttons["인증요청"]
        nextBtn = app.buttons["동의하고 시작하기"]
        
        touchScreen = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        
        phoneTF.tap()
        phoneTF.typeText("01012341234")
        
        sendCodeBtn.tap()
        XCTAssertTrue(app.buttons["재요청"].isSelected, "전화번호 입력 후, 인증요청 버튼을 클릭합니다.")
        
        touchScreen.tap()
        XCTAssertTrue(!nextBtn.isEnabled, "정보를 입력하지 않으면 버튼이 비활성화되어야합니다.")
        
        codeTF.tap()
        codeTF.typeText("41534")
        
        touchScreen.tap()
        
        XCTAssertTrue(nextBtn.isEnabled, "정보를 입력하였다면 버튼이 활성화되어야합니다.")
        XCTAssertTrue(app.buttons["재요청"].isSelected, "인증요청 버튼이 클릭된 상태여야합니다.")
        nextBtn.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
