//
//  Interval.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation
import UIKit

enum Action: String, CaseIterable {
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

class Interval: Time{
    var action: Action
    var duration: Int
    
    init(action: Action, duration: Int) {
        self.action = action
        self.duration = duration
    }
    
    public var time: String {
        return super.convertToTime(seconds: self.duration)
    }
}
