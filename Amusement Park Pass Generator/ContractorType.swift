//
//  ContractorType.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/20/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

enum ContractorType: Entrant, Nameable, Addressable, BirthDateable, Securable {
    case _1001(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case _1002(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case _1003(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case _2001(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case _2002(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
}

extension ContractorType {
    static var allTypes: [String] {
        return ["1001", "1002", "1003", "2001", "2002"]
    }
    
    var subType: SubType {
        switch self {
        case ._1001(_, _, _, _):
            return "1001"
        case ._1002(_, _, _, _):
            return "1002"
        case ._1003(_, _, _, _):
            return "1003"
        case ._2001(_, _, _, _):
            return "2001"
        case ._2002(_, _, _, _):
            return "2002"
        }
    }
    
    static func requiredInputFields(forSubType type: SubType) -> [InputField] {
        switch type {
        case "1001", "1002", "1003", "2001", "2002":
            return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode, .socialSecurityNumber, .dateOfBirth, .projectNumber]
        default:
            return []
        }
    }
    
    // Values for Area's Access
    var accessAreas: [AccessArea] {
        switch self {
        case ._1001:
            return [.amusement, .rideControl, .kitchen]
            
        case ._1002:
            return [.amusement, .rideControl, .maintenance]
            
        case ._1003:
            return [.amusement, .rideControl, .kitchen, .maintenance, .office]
            
        case ._2001:
            return [.office]
            
        case ._2002:
            return [.kitchen, .maintenance]
        }
    }
    
    // Values for Ride's Access
    var rideAccess: (allRides: Bool, skipsQueues: Bool) {
        let allRides = AccessRide.all(false).access
        let skipsQueues = AccessRide.skipsQueues(false).access
        return (allRides, skipsQueues)
    }
    
    // Values for Discount's
    var discounts: (food: Percentage, merchandise: Percentage) {
        return (0, 0)
    }
    
    var name: EntrantName? {
        switch self {
        case ._1001(let name, _, _, _):
            return name
        case ._1002(let name, _, _, _):
            return name
        case ._1003(let name, _, _, _):
            return name
        case ._2001(let name, _, _, _):
            return name
        case ._2002(let name, _, _, _):
            return name
        }
    }
    
    var address: EntrantAddress {
        switch self {
        case ._1001(_, let address, _, _):
            return address
        case ._1002(_, let address, _, _):
            return address
        case ._1003(_, let address, _, _):
            return address
        case ._2001(_, let address, _, _):
            return address
        case ._2002(_, let address, _, _):
            return address
        }
    }
    
    var birthdate: EntrantBirthdate {
        switch self {
        case ._1001(_, _, let value, _):
            return value
        case ._1002(_, _, let value, _):
            return value
        case ._1003(_, _, let value, _):
            return value
        case ._2001(_, _, let value, _):
            return value
        case ._2002(_, _, let value, _):
            return value
        }
    }
    
    var socialSecurityNumber: EntrantSocialSecurityNumber {
        switch self {
        case ._1001(_, _, _, let value):
            return value
        case ._1002(_, _, _, let value):
            return value
        case ._1003(_, _, _, let value):
            return value
        case ._2001(_, _, _, let value):
            return value
        case ._2002(_, _, _, let value):
            return value
        }
    }
    
    var projectNumber: Int {
        switch self {
        case ._1001(_, _, _, _):
            return 1001
        case ._1002(_, _, _, _):
            return 1002
        case ._1003(_, _, _, _):
            return 1003
        case ._2001(_, _, _, _):
            return 2001
        case ._2002(_, _, _, _):
            return 2002
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, address: EntrantAddress?, birthdate: EntrantBirthdate?, socialSecurityNumber:EntrantSocialSecurityNumber?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        
        switch subtype {
        case "1001":
            return passGenerator.createPass(forEntrant: ContractorType._1001(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "1002":
            return passGenerator.createPass(forEntrant: ContractorType._1002(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "1003":
            return passGenerator.createPass(forEntrant: ContractorType._1003(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "2001":
            return passGenerator.createPass(forEntrant: ContractorType._2001(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "2002":
            return passGenerator.createPass(forEntrant: ContractorType._2002(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
    
}
