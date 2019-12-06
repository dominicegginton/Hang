//
//  HangTests.swift
//  HangTests
//
//  Created by Dominic Egginton on 18/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import XCTest
@testable import Hang

class SessionsTest: XCTestCase {

    override func tearDown() {
        let sessions = Sessions.instance
        sessions.clearSessions()
        super.tearDown()
    }

    func testAddSingleSession() {
        let sessions = Sessions.instance
        do {
            let newSession = Session(name: "Test Session", intervals: [Interval(action: .hang, duration: 3)])
            try sessions.add(session: newSession)
        } catch {
            XCTFail()
        }
    }
    
    func testAddMultipleSesssions() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveSingleSession() {
        let sessions = Sessions.instance
        do {
            let newSession = Session(name: "Test Session", intervals: [Interval(action: .hang, duration: 3)])
            try sessions.add(session: newSession)
            let session = try sessions.getSession(atIndex: 0)
            XCTAssertEqual(session.name, "Test Session")
            XCTAssertEqual(session.intervals.count, 1)
            XCTAssertEqual(session.intervals[0].action, .hang)
            XCTAssertEqual(session.intervals[0].duration, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveValidSession() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            let session = try sessions.getSession(atIndex: 2)
            XCTAssertEqual(session.name, "Test Session Three")
            XCTAssertEqual(session.intervals.count, 3)
            XCTAssertEqual(session.intervals[0].action, .hang)
            XCTAssertEqual(session.intervals[0].duration, 3)
            XCTAssertEqual(session.intervals[1].action, .rest)
            XCTAssertEqual(session.intervals[1].duration, 3)
            XCTAssertEqual(session.intervals[2].action, .rest)
            XCTAssertEqual(session.intervals[2].duration, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveInvaildSession() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            try sessions.getSession(atIndex: 3)
            XCTFail()
        } catch Sessions.SessionsError.outOfRange(let index) {
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveOnlySession() {
        let sessions = Sessions.instance
        do {
            let newSession = Session(name: "Test Session", intervals: [Interval(action: .hang, duration: 3)])
            try sessions.add(session: newSession)
            XCTAssertEqual(sessions.count, 1)
            try sessions.remove(atIndex: 0)
            XCTAssertEqual(sessions.count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveValidSession() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            try sessions.remove(atIndex: 1)
            XCTAssertEqual(sessions.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveInvaliSessione() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            try sessions.remove(atIndex: 3)
            XCTFail()
        } catch Sessions.SessionsError.outOfRange(let index) {
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtValidSession() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionFour = Session(name: "Test Session Four", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            try sessions.insert(session: newSessionFour, atIndex: 1)
            
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtInvalidSession() {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            let newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionFour = Session(name: "Test Session Four", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            try sessions.insert(session: newSessionFour, atIndex: 4)
            XCTFail()
        } catch Sessions.SessionsError.outOfRange(let index) {
            XCTAssertEqual(sessions.count, 3)
            XCTAssertEqual(index, 4, "the exception shound pass array index 4")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateValidSession () {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            var newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            newSessionTwo = Session(name: "Updated Session", intervals: [Interval(action: .hang, duration: 5), Interval(action: .rest, duration: 3)])
            try sessions.update(session: newSessionTwo, atIndex: 1)
            let recivedSession = try sessions.getSession(atIndex: 1)
            XCTAssertEqual(recivedSession.name, "Updated Session")
            XCTAssertEqual(recivedSession.intervals.count, 2)
            XCTAssertEqual(recivedSession.intervals[0].action, .hang)
            XCTAssertEqual(recivedSession.intervals[0].duration, 5)
            XCTAssertEqual(recivedSession.intervals[1].action, .rest)
            XCTAssertEqual(recivedSession.intervals[1].duration, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateInvalidSession () {
        let sessions = Sessions.instance
        do {
            let newSessionOne = Session(name: "Test Session One", intervals: [Interval(action: .hang, duration: 3)])
            var newSessionTwo = Session(name: "Test Session Two", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3)])
            let newSessionThree = Session(name: "Test Session Three", intervals: [Interval(action: .hang, duration: 3), Interval(action: .rest, duration: 3), Interval(action: .rest, duration: 3)])
            try sessions.add(session: newSessionOne)
            try sessions.add(session: newSessionTwo)
            try sessions.add(session: newSessionThree)
            XCTAssertEqual(sessions.count, 3)
            newSessionTwo = Session(name: "Updated Session", intervals: [Interval(action: .hang, duration: 5), Interval(action: .rest, duration: 3)])
            try sessions.update(session: newSessionTwo, atIndex: 4)
            XCTFail()
        } catch Sessions.SessionsError.outOfRange(let index) {
            XCTAssertEqual(index, 4, "the exception shound pass array index 4")
        } catch {
            XCTFail()
        }
    }

}
