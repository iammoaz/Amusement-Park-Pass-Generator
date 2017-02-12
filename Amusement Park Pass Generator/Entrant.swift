//
//  Entrant.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

protocol Entrant {
    var accessAreas: [AccessArea] { get }
    var rideAccess: (allRides: Bool, skipsQueues: Bool) { get }
    var discounts: (food: Percentage, merchandise: Percentage) { get }
}

extension Entrant {
    // Default Values for Guest's
    var accessAreas: [AccessArea] {
        return [.amusement]
    }
    
    // Default Values for Manager and Employee's
    var rideAccess: (allRides: Bool, skipsQueues: Bool) {
        let allRides = AccessRide.all(true).access
        let skipsQueues = AccessRide.skipsQueues(true).access
        return (allRides, skipsQueues)
    }
    
    // Default Values for Guest's
    var discounts: (food: Percentage, merchandise: Percentage) {
        return (0, 0)
    }
}
