//
//  Sessions.swift
//  Hang
//
//  Created by Dominic Egginton on 20/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

class Session: Time, Codable {
    var name: String
    var intervals: [Interval]
    
    init(name: String, intervals: [Interval]) {
        self.name = name
        self.intervals = intervals
    }
    
    var totalDuration: Int {
        var duration: Int = 0
        for interval in self.intervals {
            duration += interval.duration
        }
        return duration
    }
    
    public var time: String {
        return super.convertToTime(seconds: self.totalDuration)
    }
}

class Sessions {
    
    var sessions: [Session]
    public static let instance = Sessions()
    
    init() {
        self.sessions = []
    }
    
    public var count: Int {
        return self.sessions.count
    }
    
    public func add(session: Session) throws {
        self.sessions.append(session)
    }
    
    public func getSession(atIndex index: Int) throws -> Session {
        if self.sessions.indices.contains(index) {
            return self.sessions[index]
        } else {
            throw SessionsError.outOfRange(index)
        }
    }
    
    public func insert(session newSession: Session, atIndex index: Int) throws {
        if self.sessions.indices.contains(index) || self.count == index {
            self.sessions.insert(newSession, at: index)
        } else {
            throw SessionsError.outOfRange(index)
        }
    }
    
    public func update(session updatedSession: Session, atIndex index: Int) throws {
        if self.sessions.indices.contains(index) {
            self.sessions[index] = updatedSession
        } else {
            throw SessionsError.outOfRange(index)
        }
    }
    
    public func remove(atIndex index: Int) throws {
        if self.sessions.indices.contains(index) {
            self.sessions.remove(at: index)
        } else {
            throw SessionsError.outOfRange(index)
        }
    }
    
    public func clearSessions() {
        self.sessions.removeAll()
    }
    
    enum SessionsError: Error {
        case outOfRange(_ index: Int)
    }
}
