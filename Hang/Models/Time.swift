//
//  Time.swift
//  Hang
//
//  Created by Dominic Egginton on 05/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

class Time {
    
    /**
    Creates a time strign from a Int

    - Parameter seconds: int repersenting the number of seconds

    - Returns: String in MM:SS format for easy reading
    */
    func convertToTime(seconds: Int) -> String {
        let (mins, secs) = ((seconds % 3600) / 60, (seconds % 3600) % 60)
        return "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
    }
}
