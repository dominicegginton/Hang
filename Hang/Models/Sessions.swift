//
//  Sessions.swift
//  Hang
//
//  Created by Dominic Egginton on 20/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

struct Session {
    var name: String
    var activies: [Activty]
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
}
