//
//  Employee.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/10/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

fileprivate let employeeFoodDiscount: Percentage = 15
fileprivate let employeeMerchandiseDicount: Percentage = 25

enum EmployeeType: Entrant, Nameable, Addressable, BirthDateable, Securable {
    case foodServices(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case rideServices(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber:EntrantSocialSecurityNumber)
    case maintenance(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber: EntrantSocialSecurityNumber)
}

extension EmployeeType {
    static var allTypes: [String] {
        return ["Food Services", "Ride Services", "Maintenance"]
    }
    
    var subType: SubType {
        switch self {
            case .foodServices(_, _, _, _):
                return "Food Services"
            case .rideServices(_, _, _, _):
                return "Ride Services"
            case .maintenance(_, _, _, _):
                return "Maintenance"
        }
    }
    
    static func requiredInputFields(forSubType type: SubType) -> [InputField] {
        switch type {
        case "Food Services", "Ride Services", "Maintenance":
            return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode]
        default: return []
        }
    }
    
    var accessAreas: [AccessArea] {
        switch self {
            case .foodServices:
                return [.amusement, .kitchen]
            case .maintenance:
                return [.amusement, .kitchen, .rideControl, .maintenance]
            case .rideServices:
                return [.amusement, .rideControl]
        }
    }
    
    var discounts: (food: Percentage, merchandise: Percentage) {
        return (employeeFoodDiscount, employeeMerchandiseDicount)
    }
    
    var name: EntrantName? {
        switch self {
        case .foodServices(let entrantName, _, _, _):
            return entrantName
        case .rideServices(let entrantName, _, _, _):
            return entrantName
        case .maintenance(let entrantName, _, _, _):
            return entrantName
        }
    }
    
    var address: EntrantAddress {
        switch self {
        case .foodServices(_, let entrantAddress, _, _):
            return entrantAddress
        case .rideServices(_, let entrantAddress, _, _):
            return entrantAddress
        case .maintenance(_, let entrantAddress, _, _):
            return entrantAddress
        }
    }
    
    var birthdate: EntrantBirthdate {
        switch self {
        case .foodServices(_, _, let entrantBirthdate, _):
            return entrantBirthdate
        case .rideServices(_, _, let entrantBirthdate, _):
            return entrantBirthdate
        case .maintenance(_, _, let entrantBirthdate, _):
            return entrantBirthdate
        }
    }
    
    var socialSecurityNumber: EntrantSocialSecurityNumber {
        switch self {
        case .foodServices(_, _, _, let socialSecurityNumber):
            return socialSecurityNumber
        case .rideServices(_, _, _, let socialSecurityNumber):
            return socialSecurityNumber
        case .maintenance(_, _, _, let socialSecurityNumber):
            return socialSecurityNumber
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, address: EntrantAddress?, birthdate: EntrantBirthdate?, socialSecurityNumber:EntrantSocialSecurityNumber?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        
        switch subtype {
        case "Food Services":
            return passGenerator.createPass(forEntrant: EmployeeType.foodServices(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "Ride Services":
            return passGenerator.createPass(forEntrant: EmployeeType.rideServices(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        case "Maintenance":
            return passGenerator.createPass(forEntrant: EmployeeType.maintenance(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
}
