//
//  ContractorType.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/20/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

enum ContractorType: Entrant, Nameable, Addressable, BirthDateable, Securable {
    case oneZeroZeroOne(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case oneZeroZeroTwo(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case oneZeroZeroThree(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case twoZeroZeroOne(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case twoZeroZeroTwo(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
}

extension ContractorType {
    static var allTypes: [String] {
        return ["1001", "1002", "1003", "2001", "2002"]
    }
    
    var subType: SubType {
        switch self {
        case .oneZeroZeroOne(_, _, _, _):
            return "1001"
        case .oneZeroZeroTwo(_, _, _, _):
            return "1002"
        case .oneZeroZeroThree(_, _, _, _):
            return "1003"
        case .twoZeroZeroOne(_, _, _, _):
            return "2001"
        case .twoZeroZeroTwo(_, _, _, _):
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
        case .oneZeroZeroOne:
            return [.amusement, .rideControl, .kitchen]
            
        case .oneZeroZeroTwo:
            return [.amusement, .rideControl, .maintenance]
            
        case .oneZeroZeroThree:
            return [.amusement, .rideControl, .kitchen, .maintenance, .office]
            
        case .twoZeroZeroOne:
            return [.office]
            
        case .twoZeroZeroTwo:
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
        case .oneZeroZeroOne(let name, _, _, _):
            return name
        case .oneZeroZeroTwo(let name, _, _, _):
            return name
        case .oneZeroZeroThree(let name, _, _, _):
            return name
        case .twoZeroZeroOne(let name, _, _, _):
            return name
        case .twoZeroZeroTwo(let name, _, _, _):
            return name
        }
    }
    
    var address: EntrantAddress {
        switch self {
        case .oneZeroZeroOne(_, let address, _, _):
            return address
        case .oneZeroZeroTwo(_, let address, _, _):
            return address
        case .oneZeroZeroThree(_, let address, _, _):
            return address
        case .twoZeroZeroOne(_, let address, _, _):
            return address
        case .twoZeroZeroTwo(_, let address, _, _):
            return address
        }
    }
    
    var birthdate: EntrantBirthdate {
        switch self {
        case .oneZeroZeroOne(_, _, let value, _):
            return value
        case .oneZeroZeroTwo(_, _, let value, _):
            return value
        case .oneZeroZeroThree(_, _, let value, _):
            return value
        case .twoZeroZeroOne(_, _, let value, _):
            return value
        case .twoZeroZeroTwo(_, _, let value, _):
            return value
        }
    }
    
    var socialSecurityNumber: EntrantSocialSecurityNumber {
        switch self {
        case .oneZeroZeroOne(_, _, _, let value):
            return value
        case .oneZeroZeroTwo(_, _, _, let value):
            return value
        case .oneZeroZeroThree(_, _, _, let value):
            return value
        case .twoZeroZeroOne(_, _, _, let value):
            return value
        case .twoZeroZeroTwo(_, _, _, let value):
            return value
        }
    }
    
    var projectNumber: Int {
        switch self {
        case .oneZeroZeroOne(_, _, _, _):
            return 1001
        case .oneZeroZeroTwo(_, _, _, _):
            return 1002
        case .oneZeroZeroThree(_, _, _, _):
            return 1003
        case .twoZeroZeroOne(_, _, _, _):
            return 2001
        case .twoZeroZeroTwo(_, _, _, _):
            return 2002
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, address: EntrantAddress?, birthdate: EntrantBirthdate?, socialSecurityNumber:EntrantSocialSecurityNumber?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        
        switch subtype {
        case "1001":
            return passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroOne(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "1002":
            return passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroTwo(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "1003":
            return passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroThree(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "2001":
            return passGenerator.createPass(forEntrant: ContractorType.twoZeroZeroOne(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "2002":
            return passGenerator.createPass(forEntrant: ContractorType.twoZeroZeroTwo(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
    
}
