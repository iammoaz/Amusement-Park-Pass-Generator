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

enum GuestType: Entrant, AgeVerifiable, Contactable {
    case classic
    case vip
    case child(birthdate: Birthdate)
    case senior(birthdate: Birthdate, contactInformation: EntrantDetails)
    case season(contactInformation: EntrantDetails)
}

extension GuestType {
    var discounts: (food: Percentage, merchandise: Percentage) {
        switch self {
            case .vip, .season:
                return (vipFoodDiscount, vipMerchandiseDicount)
            case .senior:
                return (vipFoodDiscount, vipMerchandiseDicount)
            default:
                return (0, 0)
        }
    }
    
    var rideAccess: (allRides: Bool, skipsQueues: Bool) {
        switch self {
            case .vip, .season, .senior:
                let allRides = AccessRide.all(true).access
                let skipsQueues = AccessRide.skipsQueues(true).access
                return (allRides, skipsQueues)
            default:
                return (true, false)
        }
    }
    
    var contactInformation: EntrantDetails? {
        switch self {
        case .season(let contactInformation):
            return contactInformation
        case .senior(birthdate: _, contactInformation: let contactInformation):
            return contactInformation
        default:
            return nil
        }
    }
    
    var contactDetails: String {
        return ""
    }
}
