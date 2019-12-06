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
    
    // Sessions
    var sessions: [Session]
    // Singleton instacle here.
    public static let instance = Sessions()
    
    /**
    Create new instance of Sessions

    - Returns: A new insatnce of Sessions
    */
    init() {
        // Setup Instance
        self.sessions = []
        self.load()
    }
    
    /**
    Saves current array of sessions in user defaults
    */
    func save() {
        // Get encoded data
        if let data = try? JSONEncoder().encode(self.sessions) {
            // Get JSON string frommat.
            let jsonString = String(data: data, encoding: .utf8)
            // Save JSON into user defaults
            UserDefaults.standard.set(jsonString!, forKey: "sessions")
        }
    }
    
    /**
        Loads current array of Sessions into user defaults
     */
    func load() {
        // if jason string can be read from user.defaults then decode data
        if let jsonString = UserDefaults.standard.value(forKey: "sessions") as? String {
            let decorder = JSONDecoder()
            let sessions = try? decorder.decode([Session].self, from: jsonString.data(using: .utf8)!)
            // Set sessions
            self.sessions = sessions!
        }
    }
    
    /**
    Get number of sessions

    - Returns: returns number repersenting the legth of the sessions array
    */
    public var count: Int {
        return self.sessions.count
    }
    
    /**
    Add sessions to system

    - Parameter session: The new session being addded

    - Returns: A new insatnce of Session
    */
    public func add(session: Session) throws {
        self.sessions.append(session)
        self.save()
    }
    
    /**
        Get session with all details.
     
     - Parameter atIndex: InT
     
     - Returns Session
    */
    public func getSession(atIndex index: Int) throws -> Session {
        // Check to see if index is out of rnage
        if self.sessions.indices.contains(index) {
            return self.sessions[index]
        } else {
            throw SessionsError.outOfRange(index)
        }
    }
    
    /**
        Insert given session into model.
     
     - Parameter atIndex: Int
    */
    public func insert(session newSession: Session, atIndex index: Int) throws {
        // Check to see if index is out of rnage
        if self.sessions.indices.contains(index) || self.count == index {
            self.sessions.insert(newSession, at: index)
        } else {
            throw SessionsError.outOfRange(index)
        }
        self.save()
    }
    
    /**
        Update a session
     
     - Parameter atIndex: Int index of the session to be updated
     - Parameter session: Session to be updated
    */
    public func update(session updatedSession: Session, atIndex index: Int) throws {
        // Check to see if index is out of rnage
        if self.sessions.indices.contains(index) {
            // update session
            self.sessions[index] = updatedSession
        } else {
            throw SessionsError.outOfRange(index)
        }
        // Save
        self.save()
    }
    
    /**
        Remove a session from
     
     - Parameter atIndex: Int repersenting the index of session to delete.
    */
    public func remove(atIndex index: Int) throws {
        // Check to see if index is out of rnage
        if self.sessions.indices.contains(index) {
            // Remove
            self.sessions.remove(at: index)
        } else {
            throw SessionsError.outOfRange(index)
        }
        self.save()
    }
    
    /**
        Clears Sessions Array and Saves to disk
    */
    public func clearSessions() {
        // Remove all sessions
        self.sessions.removeAll()
        // Save to disk
        self.save()
    }
    
    // Error Enum
    enum SessionsError: Error {
        case outOfRange(_ index: Int)
    }
}
