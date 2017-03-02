//
//  Pass.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

protocol Passable {
    var entrant: Entrant { get }
    var passID: PassID { get }
    var foodDiscount: Percentage { get }
    var merchandiseDiscount: Percentage { get }
    var allRideAccess: Bool { get }
    var skipsQueues: Bool { get }
    var accessAreas: [AccessArea] { get }
    var addressDetails: String { get }
    func hasAccess(toArea area: AccessArea) -> Bool
//    func hasAccess(toDiscount for: DiscountType) -> Bool
}

enum PassError: Error {
    case invalidContactInfoProvided(message: String)
    case invalidDateFormat(message: String)
    case failsChildAgeRequirement(message: String)
    case accessSoundQueueError(message: String)
    case doubleSwipeError(message: String)
}

// Returns Access Entitlements for instance of pass
extension AccessPassGenerator.AccessPass {
    var allRideAccess: Bool {
        return entrant.rideAccess.allRides
    }
    
    var skipsQueues: Bool {
        return entrant.rideAccess.skipsQueues
    }
    
    var accessAreas: [AccessArea] {
        return entrant.accessAreas
    }
    
    func hasAccess(toArea area: AccessArea) -> Bool {
        return accessAreas.contains(area)
    }
    
    var foodDiscount: Percentage {
        let foodDiscount = entrant.discounts.food
        return foodDiscount
    }
    
    var merchandiseDiscount: Percentage {
        return entrant.discounts.merchandise
    }
    
    var name: EntrantName? {
        switch entrant {
        case is EmployeeType:
            let entrant = self.entrant as! EmployeeType
            return entrant.name
        case is ManagerType:
            let entrant = self.entrant as! ManagerType
            return entrant.name
        case is VendorType:
            let entrant = self.entrant as! VendorType
            return entrant.name
        case is ContractorType:
            let entrant = self.entrant as! ContractorType
            return entrant.name
        default:
            return nil
        }
    }
    
    // Optinal contact information
    var address: EntrantAddress? {
        switch entrant {
            case is EmployeeType:
                let employeeType = entrant as! EmployeeType
                return employeeType.address
            case is ManagerType:
                let managerType = entrant as! ManagerType
                return managerType.address
            default:
                return nil
        }
    }
    
    var addressDetails: String {
        if entrant is Addressable && entrant is EmployeeType {
            let hourlyEmployee = entrant as! EmployeeType
            return hourlyEmployee.addressDetails
        } else if entrant is Addressable && entrant is ManagerType {
            let manager = entrant as! ManagerType
            return manager.addressDetails
        }
        return "Entrant has no contact details"
    }
    
    // Check age limit
    var isVerified: Bool {
        guard entrant is AgeVerifiable && entrant is GuestType else { return false }
        
        switch entrant as! GuestType {
        case .child(birthdate: let date):
            do {
                let verified = try birthdate(dateString: date.dateOfBirth, meetsRequirement: maxChildAge)
                return verified
            } catch PassError.failsChildAgeRequirement(message: let message) {
                print(message)
            } catch PassError.invalidDateFormat(message: let message) {
                print(message)
            } catch let error {
                print("\(error)")
            }
        default:
            break
        }
        
        return false
    }
}
