//
//  Guest.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

fileprivate let vipFoodDiscount: Percentage = 10
fileprivate let vipMerchandiseDicount: Percentage = 20

enum GuestType: Entrant, AgeVerifiable {
    case classic
    case vip
    case child(birthdate: Birthdate)
}

extension GuestType {
    var discounts: (food: Percentage, merchandise: Percentage) {
        switch self {
            case .vip:
                return (vipFoodDiscount, vipMerchandiseDicount)
            default:
                return (0, 0)
        }
    }
    
    var rideAccess: (allRides: Bool, skipsQueues: Bool) {
        switch self {
            case .vip:
                let allRides = AccessRide.all(true).access
                let skipsQueues = AccessRide.skipsQueues(true).access
                return (allRides, skipsQueues)
            default:
                return (true, false)
        }
    }
}
