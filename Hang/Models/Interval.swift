//
//  Interval.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

enum Action: String, CaseIterable {
    case hang = "Hang"
    case rest = "Rest"
}

struct Interval {
    var action: Action?
    var duration: Int
}
