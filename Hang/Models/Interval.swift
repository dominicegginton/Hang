//
//  Interval.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import Foundation

enum Activty {
    case hang
    case rest
}

struct Interval {
    var activty: Activty
    var duration: Int
    var weight: Int
}
