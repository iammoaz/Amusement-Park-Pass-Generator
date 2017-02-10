//
//  Ride.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/10/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

enum Ride {
    case all(Bool)
    case skipsQueues(Bool)
}

extension Ride {
    var access: Bool {
        switch self {
            case .all(let success): return success
            case .skipsQueues(let success): return success
        }
    }
}
