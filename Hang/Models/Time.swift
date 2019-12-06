//
//  Time.swift
//  Hang
//
//  Created by Dominic Egginton on 05/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

class Time {
    
    func convertToTime(seconds: Int) -> String {
        let (mins, secs) = ((seconds % 3600) / 60, (seconds % 3600) % 60)
        return "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
    }
}
