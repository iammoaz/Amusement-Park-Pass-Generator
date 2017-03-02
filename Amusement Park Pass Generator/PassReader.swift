//
//  PassReader.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

typealias AccessMessage = String

protocol PassReadable {
    func areaAccess(forPass pass: Passable) -> AccessMessage
    func rideAccess(forPass pass: Passable) -> AccessMessage
    func discountType(forPass pass: Passable) -> AccessMessage
    func birthdayAlert(forPass pass: Passable) -> AccessMessage
    func swipeAccessFor(_ pass: Passable, hasAccessTo area: AccessArea) -> (Bool, message: AccessMessage)
    func playSound(_ success: Bool)
}

struct PassReader: PassReadable {
    
    static let instance = PassReader()
    let soundManager = SoundManager()
    
    fileprivate var lastPassID: PassID?
    fileprivate var lastTimeStamp: TimeInterval?
    fileprivate var minWaitTime: TimeInterval = 10
    fileprivate var timeStamp: TimeInterval {
        return Date().timeIntervalSince1970
    }
}

// Returns message's of all accessable entitlements for a given pass
extension PassReader {
    func areaAccess(forPass pass: Passable) -> AccessMessage {
        let message: AccessMessage = "Pass has access to: "
        let accessAreas = pass.accessAreas.map { (accessArea) -> String in
            accessArea.rawValue
        }
        
        if accessAreas.count > 1 {
            let prefix = accessAreas.prefix(accessAreas.count - 1)
            let suffix = accessAreas.suffix(1).first!
            return "\(message) \(prefix.joined(separator: " area, ")) and \(suffix) area"
        } else {
            return "\(message) \(accessAreas[0]) area"
        }
    }
    
    func rideAccess(forPass pass: Passable) -> AccessMessage {
        var message = "Pass has access to: "
        let allRideAccess = pass.allRideAccess
        let skipsQueues = pass.skipsQueues
        message += allRideAccess ? "All Rides" : ""
        
        if allRideAccess && skipsQueues {
            message += " ,and skips lines for queues"
        }
        
        return message
    }
    
    func discountType(forPass pass: Passable) -> AccessMessage {
        let foodDiscount = pass.foodDiscount
        let merchandiseDiscount = pass.merchandiseDiscount
        
        if foodDiscount == 0 && merchandiseDiscount == 0 {
            return "This pass is not eligible for any discounts"
        } else {
            return "This pass gets a food discount of \(foodDiscount)%, and a merchandise discount of \(merchandiseDiscount)%"
        }
    }
    
    // Swipe Access Methods on different access entitlements
    
    // Area Access
    func swipeAccessFor(_ pass: Passable, hasAccessTo area: AccessArea) -> (Bool, message: AccessMessage) {
        let success = pass.hasAccess(toArea: area)
        playSound(success)
        
        switch area {
        case .amusement:
            return (success, success ? "Amusement Area: Access Granted" : "Amusement Area: Access Denied")
        case .kitchen:
            return (success, success ? "Kitchen Area: Access Granted" : "Kitchen Area: Access Denied")
        case .maintenance:
            return (success, success ? "Maintenance Area: Access Granted" : "Maintenance Area: Access Denied")
        case .office:
            return (success, success ? "Office Area: Access Granted" : "Office Area: Access Denied")
        case .rideControl:
            return (success, success ? "Ride Control: Access Granted" : "Ride Control: Access Denied")
        }
    }
    
    // Discounts
    func swipeAccessFor(_ pass: Passable, discountFor type: DiscountType) -> (Bool, message: AccessMessage) {
        switch type {
        case .food(pass.foodDiscount):
            if pass.foodDiscount == 0 {
                playSound(false)
                return (false, "No discount on Food")
            } else {
                playSound(true)
                return (true, "\(pass.foodDiscount)% discount on Food")
            }
            
        case .merchandise(pass.merchandiseDiscount):
            if pass.merchandiseDiscount == 0 {
                playSound(false)
                return (false, "No discount on Merchandise")
            } else {
                playSound(true)
                return (true, "\(pass.merchandiseDiscount)% discount on Merchandise")
            }
        default:
            playSound(false)
            return (true, "Not eligible for any discounts")
        }
    }
    
    // Ride Access
    mutating func swipeAccessFor(_ pass: Passable, hasRideAccess type: AccessRide) -> (Bool, message: AccessMessage) {
        do {
            let _ = try isValidSwipe(forID: pass.passID)
        } catch PassError.doubleSwipeError(message: let message) {
            return(false, message)
        } catch let error {
            return (false, "\(error)")
        }
        
        var hasAccess: Bool
        var message: AccessMessage
        
        switch type {
        case .all(let success):
            hasAccess = success
            message = "all rides"
        case .skipsQueues(let success):
            hasAccess = success
            message = "skip lines for rides"
        }
        
        playSound(hasAccess)
        
        lastPassID = pass.passID
        lastTimeStamp =  timeStamp
        return (hasAccess, hasAccess ? "This pass has access to \(message)" : "This pass doesn't have access to \(message)")
    }

    
    // Displays error message if pass is reswiped
    private func isValidSwipe(forID id: PassID) throws -> Bool {
        let currentTime = timeStamp
        guard lastPassID != nil, let lastStamp = lastTimeStamp  else { return false }
        guard currentTime - lastStamp > minWaitTime else {
            playSound(currentTime - lastStamp > minWaitTime)
            throw PassError.doubleSwipeError(message: "Swipe error. This pass is already swiped")
        }
        return true
    }
    
    // Display Birthday Message and Call Alert
    func displayBirthdayMessage(forPass pass: Passable, controller: UIViewController) {
        let message = birthdayAlert(forPass: pass)
        if !message.isEmpty {
            print(message)
            Theme.displayAlert(title: "It's your Birthday!", message: message, viewController: controller)
        }
    }
    
    func birthdayAlert(forPass pass: Passable) -> AccessMessage {
        if pass.entrant is ManagerType {
            switch pass.entrant as! ManagerType {
            case .manager(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
            }
        }
        
        if pass.entrant is VendorType {
            switch pass.entrant as! VendorType {
            case .acme(name: let name, birthdate: let date, visitdate: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
            
            case .orkin(name: let name, birthdate: let date, visitdate: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case .fedex(name: let name, birthdate: let date, visitdate: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case .nwElectrical(name: let name, birthdate: let date, visitdate: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
            }
        }
        
        if pass.entrant is ContractorType {
            switch pass.entrant as! ContractorType {
            case ._1001(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case ._1002(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case ._1003(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case ._2001(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case ._2002(name: let name, address: _, birthdate: let date, socialSecurityNumber: _):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
            }
        }
        
        if pass.entrant is GuestType {
            switch pass.entrant as! GuestType {
            case .classic, .vip:
                return ""
                
            case .child(birthdate: let date):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday!" : ""
                
            case .season(name: let name, address: _, birthdate: let date):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
                
            case .senior(name: let name, birthdate: let date):
                let isMatch = isBirthday(forPass: pass, withDate: date.dateOfBirth)
                return isMatch ? "Happy Birthday \(name.firstName!)!" : ""
            }
        }
        
        return ""
    }
    
    // Compare Date with Birthdate
    private func isBirthday(forPass pass: Passable, withDate date: Birthdate) -> Bool {
        let today = Date()
        let birthdate = Date.getDateFromString(stringDate: date)
        let todayDay = Calendar.current.component(.day, from: today)
        let todayMonth = Calendar.current.component(.month, from: today)
        let birthdateDay = Calendar.current.component(.day, from: birthdate!)
        let birthdateMonth = Calendar.current.component(.month, from: birthdate!)
        
        guard birthdateDay == todayDay && birthdateMonth == todayMonth else { return false }
        return true
    }
    
    // Play Sounds
    func playSound(_ success: Bool) {
        if success {
            soundManager.playAccessGrantedSound()
        } else {
            soundManager.playAccessDeniedSound()
        }
    }
}
