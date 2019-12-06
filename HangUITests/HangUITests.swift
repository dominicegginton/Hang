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
    
    func testAddVailddSession() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.textFields["sessionNameTxtBox"].tap()
        app.textFields["sessionNameTxtBox"].typeText("Test Session")
        app.buttons["doneBtn"].tap()
        app.buttons["addIntervalBtn"].tap()
        XCTAssertTrue(app.tables.element.exists)
        app.tables.element.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.steppers.element.exists)
        for _ in 0...3 {
            app.steppers.element.tap()
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        XCTAssertTrue(app.navigationBars["Test Session"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Hang"].exists)
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
    }
    
    func testSelectActivity() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.textFields["sessionNameTxtBox"].tap()
        app.textFields["sessionNameTxtBox"].typeText("Test Session")
        app.buttons["doneBtn"].tap()
        app.buttons["addIntervalBtn"].tap()
        XCTAssertTrue(app.tables.element.exists)
        app.tables.element.cells.element(boundBy: 0).tap()
        app.tables.element.cells.element(boundBy: 1).tap()
        app.tables.element.cells.element(boundBy: 2).tap()
    }
    
    func testDeleteInterval() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.textFields["sessionNameTxtBox"].tap()
        app.textFields["sessionNameTxtBox"].typeText("Test Session")
        app.buttons["doneBtn"].tap()
        app.buttons["addIntervalBtn"].tap()
        XCTAssertTrue(app.tables.element.exists)
        app.tables.element.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.steppers.element.exists)
        for _ in 0...3 {
            app.steppers.element.tap()
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        XCTAssertTrue(app.navigationBars["Test Session"].exists)
        app.tables.element.cells.element(boundBy: 0).swipeLeft()
        app.tables.element.cells.element(boundBy: 0).buttons["Delete"].tap()
        XCTAssertTrue(!app.tables.element.cells.element(boundBy: 0).exists)
    }
    
    func testDeleteSession() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Hang"].exists)
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        app.tables.element.cells.element(boundBy: 0).swipeLeft()
        app.tables.element.cells.element(boundBy: 0).buttons["Delete"].tap()
        XCTAssertTrue(!app.tables.element.cells.element(boundBy: 0).exists)
    }
    
    func testEditSession() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.textFields["sessionNameTxtBox"].tap()
        app.textFields["sessionNameTxtBox"].typeText("Test Session")
        app.buttons["doneBtn"].tap()
        app.buttons["addIntervalBtn"].tap()
        XCTAssertTrue(app.tables.element.exists)
        app.tables.element.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.steppers.element.exists)
        for _ in 0...3 {
            app.steppers.element.tap()
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        XCTAssertTrue(app.navigationBars["Test Session"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Hang"].exists)
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        app.tables.element.cells.element(boundBy: 0).swipeRight()
        app.tables.element.cells.element(boundBy: 0).buttons["Edit"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
    }
    
    func testStartSesstionTimer() {
        let app = XCUIApplication()
        app.buttons["newSessionBtn"].tap()
        XCTAssertTrue(app.navigationBars["Session"].exists)
        app.textFields["sessionNameTxtBox"].tap()
        app.textFields["sessionNameTxtBox"].typeText("Test Session")
        app.buttons["doneBtn"].tap()
        app.buttons["addIntervalBtn"].tap()
        XCTAssertTrue(app.tables.element.exists)
        app.tables.element.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.steppers.element.exists)
        for _ in 0...3 {
            app.steppers.element.tap()
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        XCTAssertTrue(app.navigationBars["Test Session"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Hang"].exists)
        XCTAssertTrue(app.tables.element.cells.element(boundBy: 0).exists)
        app.tables.element.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["00:00"].exists)
        app.buttons["timerControlBtn"].tap()
        sleep(10)
        XCTAssertTrue(!app.tables.element.cells.element(boundBy: 0).exists)
    }
}
