//
//  Sessions.swift
//  Hang
//
//  Created by Dominic Egginton on 20/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

class Session: Time, Codable {
    
    // Session Name
    var name: String
    // Session Intervals
    var intervals: [Interval]
    
    /**
    Creates a new instance of Session

    - Parameter name: The name of the session
    - Parameter intervals: Array of intervals making up the session

    - Returns: A new insatnce of Session
    */
    init(name: String, intervals: [Interval]) {
        // Set instance vars
        self.name = name
        self.intervals = intervals
    }
    
    /**
    Gets total time of the instance

    - Returns: Int repersenting the total duration of the session
    */
    var totalDuration: Int {
        // Loop over intervals return the total of there durations
        var duration: Int = 0
        for interval in self.intervals {
            duration += interval.duration
        }
        return duration
    }
    
    /**
    Gets a human readble string of the duration of the session in MM:SS format

    - Returns: String repersenting the time of the sesion
    */
    public var time: String {
        // Call time class as parent
        return super.convertToTime(seconds: self.totalDuration)
    }
}

class Sessions {
    
    var sessions: [Session]
    public static let instance = Sessions()
    
    init() {
        self.sessions = []
        self.load()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self.sessions) {
            let jsonString = String(data: data, encoding: .utf8)
            print(">>> saving \(jsonString!)")
            UserDefaults.standard.set(jsonString!, forKey: "sessions")
        }
    }
    
    func load() {
        if let jsonString = UserDefaults.standard.value(forKey: "sessions") as? String {
            let decorder = JSONDecoder()
            let sessions = try? decorder.decode([Session].self, from: jsonString.data(using: .utf8)!)
            self.sessions = sessions!
        }
    }
    
    public var count: Int {
        return self.sessions.count
    }
    
    public func add(session: Session) throws {
        self.sessions.append(session)
        self.save()
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
        self.save()
    }
    
    public func update(session updatedSession: Session, atIndex index: Int) throws {
        if self.sessions.indices.contains(index) {
            self.sessions[index] = updatedSession
        } else {
            throw SessionsError.outOfRange(index)
        }
        self.save()
    }
    
    public func remove(atIndex index: Int) throws {
        if self.sessions.indices.contains(index) {
            self.sessions.remove(at: index)
        } else {
            throw SessionsError.outOfRange(index)
        }
        self.save()
    }
    
    public func clearSessions() {
        self.sessions.removeAll()
        self.save()
    }
    
    enum SessionsError: Error {
        case outOfRange(_ index: Int)
    }
}
