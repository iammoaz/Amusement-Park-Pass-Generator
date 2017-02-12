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
    var contactDetails: String { get }
    func hasAccess(toArea area: AccessArea) -> Bool
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
    
    // Optinal contact information
    var contactInfo: EntrantDetails? {
        switch entrant {
            case is EmployeeType:
                let employeeType = entrant as! EmployeeType
                return employeeType.contactInformation
            case is ManagerType:
                let managerType = entrant as! ManagerType
                return managerType.contactInformation
            default:
                return nil
        }
    }
    
    var contactDetails: String {
        if entrant is Contactable && entrant is EmployeeType {
            let hourlyEmployee = entrant as! EmployeeType
            return hourlyEmployee.contactDetails
        } else if entrant is Contactable && entrant is ManagerType {
            let manager = entrant as! ManagerType
            return manager.contactDetails
        }
        return "Entrant has no contact details"
    }
    
    // Check age limit
    var isVerified: Bool {
        guard entrant is AgeVerifiable && entrant is GuestType else { return false }
        
        switch entrant as! GuestType {
        case .child(birthdate: let date):
            do {
                let verified = try birthdate(dateString: date, meetsRequirement: maxChildAge)
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
