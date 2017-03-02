//
//  VendorType.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/20/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

enum VendorType: Entrant, Nameable, BirthDateable, VisitDateable {
    case acme(name: EntrantName, birthdate: EntrantBirthdate, visitdate: EntrantVisitDate)
    case orkin(name: EntrantName, birthdate: EntrantBirthdate, visitdate: EntrantVisitDate)
    case fedex(name: EntrantName, birthdate: EntrantBirthdate, visitdate: EntrantVisitDate)
    case nwElectrical(name: EntrantName, birthdate: EntrantBirthdate, visitdate: EntrantVisitDate)
}

extension VendorType {
    static var allTypes: [String] {
        return ["ACME", "Orkin", "Fedex", "NW Electrical"]
    }
    
    var subType: SubType {
        switch self {
        case .acme(_, _, _):
            return "ACME"
        case .orkin(_, _, _):
            return "Orkin"
        case .fedex(_, _, _):
            return "Fedex"
        case .nwElectrical(_, _, _):
            return "NW Electrical"
        }
    }
    
    static func requiredInputFields(forSubType type: SubType) -> [InputField] {
        switch type {
        case "ACME", "Orkin", "Fedex", "NW Electrical":
            return [.firstName, .lastName, .dateOfBirth, .dateOfVisit, .companyName]
        default:
            return []
        }
    }
    // Values for Area's Access
    var accessAreas: [AccessArea] {
        switch self {
        case .acme:
            return [.kitchen]
        case .orkin:
            return [.amusement, .rideControl, .kitchen]
        case .fedex:
            return [.maintenance, .office]
        case .nwElectrical:
            return [.amusement, .rideControl, .kitchen, .maintenance, .office]
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
        case .acme(let name, _, _):
            return name
        case .orkin(let name, _, _):
            return name
        case .fedex(let name, _, _):
            return name
        case .nwElectrical(let name, _, _):
            return name
        }
    }
    
    var birthdate: EntrantBirthdate {
        switch self {
        case .acme(_, let birthdate, _):
            return birthdate
        case .orkin(_, let birthdate, _):
            return birthdate
        case .fedex(_, let birthdate, _):
            return birthdate
        case .nwElectrical(_, let birthdate, _):
            return birthdate
        }
    }
    
    var visitdate: EntrantVisitDate {
        switch self {
        case .acme(_, _, let visitdate):
            return visitdate
        case .orkin(_, _, let visitdate):
            return visitdate
        case .fedex(_, _, let visitdate):
            return visitdate
        case .nwElectrical(_, _, let visitdate):
            return visitdate
        }
    }
    
    var company: String {
        switch self {
        case .acme(_, _, _):
            return "ACME"
        case .orkin(_, _, _):
            return "Orkin"
        case .fedex(_, _, _):
            return "Fedex"
        case .nwElectrical(_, _, _):
            return "NW Electrical"
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, birthdate: EntrantBirthdate?, visitdate: EntrantVisitDate?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        
        switch subtype {
        case "ACME":
            return passGenerator.createPass(forEntrant: VendorType.acme(name: name!, birthdate: birthdate!, visitdate: visitdate!)).entrantPass
            
        case "Orkin":
            return passGenerator.createPass(forEntrant: VendorType.orkin(name: name!, birthdate: birthdate!, visitdate: visitdate!)).entrantPass
            
        case "Fedex":
            return passGenerator.createPass(forEntrant: VendorType.fedex(name: name!, birthdate: birthdate!, visitdate: visitdate!)).entrantPass
            
        case "NW Electrical":
            return passGenerator.createPass(forEntrant: VendorType.nwElectrical(name: name!, birthdate: birthdate!, visitdate: visitdate!)).entrantPass
            
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
    
}
