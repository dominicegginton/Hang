//
//  Interval.swift
//  HangTests
//
//  Created by Dominic Egginton on 06/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import XCTest
@testable import Hang

class IntervalTest: XCTestCase {

    func testHangColor() {
        let interval = Interval(action: .hang, duration: 3)
        XCTAssertEqual(interval.action.color, .systemGreen)
    }
    
    func testRestColor() {
        let interval = Interval(action: .rest, duration: 3)
        XCTAssertEqual(interval.action.color, .systemRed)
    }
    
    func testLongRestColor() {
        let interval = Interval(action: .longRest, duration: 3)
        XCTAssertEqual(interval.action.color, .systemBlue)
    }
    
    func testTime() {
        let interval = Interval(action: .hang, duration: 3)
        XCTAssertEqual(interval.time, "00:03")
    }

}
