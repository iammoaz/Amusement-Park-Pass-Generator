//
//  Manager.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

fileprivate let managerFoodDiscount: Percentage = 25
fileprivate let managerMerchandiseDiscount: Percentage = 25

// Enum to hold Manager types i.e shift, senior, general
enum ManagerType: Entrant, Nameable, Addressable, BirthDateable, Securable {
    case manager(name: EntrantName, address: EntrantAddress, birthdate: EntrantBirthdate, socialSecurityNumber: EntrantSocialSecurityNumber)
}

extension ManagerType {
    static var allTypes: [String] {
        return ["General Manager"]
    }
    
    var subType: SubType {
        switch self {
        case .manager(_, _, _, _):
            return "General Manager"
        }
    }
    
    static func requiredInputFields(forSubType type: SubType) -> [InputField] {
        switch type {
        case "General Manager":
            return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode, .socialSecurityNumber, .dateOfBirth]
        default:
            return []
        }
    }
    
    var discounts: (food: Percentage, merchandise: Percentage) {
        let foodDiscount = DiscountType.food(managerFoodDiscount).percentage
        let merchandiseDiscount = DiscountType.merchandise(managerMerchandiseDiscount).percentage
        return (foodDiscount, merchandiseDiscount)
    }
    
    var accessAreas: [AccessArea] {
        return [.amusement, .kitchen, .maintenance, .rideControl, .office]
    }
    
    var name: EntrantName? {
        switch self {
        case .manager(let name, _, _, _):
            return name
        }
    }
    
    var address: EntrantAddress {
        switch self {
        case .manager(_, let address, _, _):
            return address
        }
    }
    
    var birthdate: EntrantBirthdate {
        switch self {
        case .manager(_, _, let birthdate, _):
            return birthdate
        }
    }
    
    var socialSecurityNumber: EntrantSocialSecurityNumber {
        switch self {
            case .manager(_, _, _, let socialSecurityNumber):
                return socialSecurityNumber
        }
    }
    
    static func createPass(for subtype: SubType, name: EntrantName?, address: EntrantAddress?, birthdate: EntrantBirthdate?, socialSecurityNumber:EntrantSocialSecurityNumber?) -> AccessPassGenerator.AccessPass {
        let passGenerator = AccessPassGenerator.instance
        
        switch subtype {
        case "General Manager":
            return passGenerator.createPass(forEntrant: ManagerType.manager(name: name!, address: address!, birthdate: birthdate!, socialSecurityNumber: socialSecurityNumber!)).entrantPass
            
        default:
            return AccessPassGenerator.instance.createPass(forEntrant: GuestType.classic).entrantPass
        }
    }
}
