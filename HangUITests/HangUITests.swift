//
//  HangUITests.swift
//  HangUITests
//
//  Created by Dominic Egginton on 18/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import XCTest

class HangUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testAddEmptySession() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Hang"].exists)
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
    }
    
}
