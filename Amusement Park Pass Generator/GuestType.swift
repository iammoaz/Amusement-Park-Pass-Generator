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
    case child(birthdate: EntrantBirthdate)
    case senior(name: EntrantName, birthdate: EntrantBirthdate)
    case season(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate)
}

extension GuestType {
    
    static var allTypes: [String] {
        return ["Classic", "VIP", "Child", "Senior", "Season"]
    }
    
    var subType: SubType {
        switch self {
            case .classic:
                return "Classic"
            case .vip:
                return "VIP"
            case .child:
                return "Child"
            case .senior:
                return "Senior"
            case .season:
                return "Season"
        }
    }
    
    static func requiredInputFields(forSubType type: SubType) -> [InputField] {
        switch type {
            case "Child":
                return [.dateOfBirth]
            case "Senior":
                return [.firstName, .lastName, .dateOfBirth,]
            case "Season":
                return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode, .dateOfBirth]
            default: return []
        }
    }
    
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
    
    var name: EntrantName? {
        switch self {
        case .senior(let name, _):
            return name
            
        case .season(let name, _, _):
            return name
        
        default:
            return nil
        }
    }
    
    var address: EntrantAddress? {
        switch self {
        case .season(_, let address, _):
            return address
        default:
            return nil
        }
    }
    
    var birthdate: EntrantBirthdate? {
        switch self {
        case .child(let birthdate):
            return birthdate
        case .senior(_, let birthdate):
            return birthdate
        case .season(_, _, let birthdate):
            return birthdate
        default:
            return nil
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, address: EntrantAddress?, birthdate: EntrantBirthdate?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        switch subtype {
        case "Classic":
            return passGenerator.createPass(forEntrant: GuestType.classic).entrantPass
        
        case "VIP":
            return passGenerator.createPass(forEntrant: GuestType.vip).entrantPass
        
        case "Child":
            return passGenerator.createPass(forEntrant: GuestType.child(birthdate: birthdate!)).entrantPass
            
        case "Senior":
            return passGenerator.createPass(forEntrant: GuestType.senior(name: name!, birthdate: birthdate!)).entrantPass
            
        case "Season":
            return passGenerator.createPass(forEntrant: GuestType.season(name: name!, address: address!, birthdate: birthdate!)).entrantPass
        
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
}
