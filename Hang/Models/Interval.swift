//
//  Interval.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation
import UIKit

enum Action: String, CaseIterable, Codable {
    case hang = "Hang"
    case rest = "Rest"
    case longRest = "Long Rest"
    
    var color: UIColor {
        switch self {
        case .hang:
            return .systemGreen
        case .rest:
            return .systemRed
        case .longRest:
            return .systemBlue
        }
    }
}

class Interval: Time, Codable{
    // Action being carried out with the interval
    var action: Action
    // Duration of the interval in seconds
    var duration: Int
    
    /**
    Inilizes a Interval Class

    - Parameter action: the actioing being carried out within the interval

    - Returns: Self
    */
    init(action: Action, duration: Int) {
        // Setup Instance
        self.action = action
        self.duration = duration
    }
    
    /**
     Time reersents the human readable time

    - Returns: String repersetning the total xtime of the interval
    */
    public var time: String {
        return super.convertToTime(seconds: self.duration)
    }
}
