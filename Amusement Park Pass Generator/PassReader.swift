//
//  PassReader.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

typealias AccessMessage = String

protocol PassReadable {
    func areaAccess(forPass pass: Passable) -> AccessMessage
    func rideAccess(forPass pass: Passable) -> AccessMessage
    func discountType(forPass pass: Passable) -> AccessMessage
    func birthdayAlert(forPass pass: Passable) -> AccessMessage
    func swipeAccessFor(_ pass: Passable, hasAccessTo area: AccessArea) -> Bool
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
    func swipeAccessFor(_ pass: Passable, hasAccessTo area: AccessArea) -> Bool {
        let success = pass.hasAccess(toArea: area)
        displayBirthdayMessage(forPass: pass)
        playSound(success)
        return success
    }
    
    // Discounts
    func swipeAccessFor(_ pass: Passable, discountFor type: DiscountType) -> AccessMessage {
        var discountType: AccessMessage
        var discountAmount: AccessMessage
        
        switch type {
            case .food(let foodDiscount):
                discountType =  "Food"
                discountAmount = "\(foodDiscount)"
            case .merchandise(let merchandiseDiscount):
                discountType = "Merchandise"
                discountAmount = "\(merchandiseDiscount)"
        }
        
        displayBirthdayMessage(forPass: pass)
        playSound(discountAmount != "0")
        
        return discountAmount == "0" ? "This pass doesn't have a \(discountType) discount" :
        "This pass has a \(discountAmount)% \(discountType) discount"
    }
    
    // Ride Access
    mutating func swipeAccessFor(_ pass: Passable, hasRideAccess type: AccessRide) -> AccessMessage {
        do {
            let _ = try isValidSwipe(forID: pass.passID)
        } catch PassError.doubleSwipeError(message: let message) {
            return(message)
        } catch let error {
            return ("\(error)")
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
        
        displayBirthdayMessage(forPass: pass)
        playSound(hasAccess)
        
        lastPassID = pass.passID
        lastTimeStamp =  timeStamp
        
        return hasAccess ? "This pass has access to \(message)" : "This pass doesn't have access to \(message)"
    }
    
    // Displays error message if pass is reswiped
    private func isValidSwipe(forID id: PassID) throws -> Bool {
        let currentTime = timeStamp
        guard let lastUsedID = lastPassID, let lastStamp = lastTimeStamp  else { return false }
        guard currentTime - lastStamp > minWaitTime else {
            playSound(currentTime - lastStamp > minWaitTime)
            throw PassError.doubleSwipeError(message: "Swipe error. Check pass ID. This pass's id: \(lastUsedID) is already swiped")
        }
        return true
    }
    
    // Display Birthday Message and Call Alert
    private func displayBirthdayMessage(forPass pass: Passable) {
        let birthDayMessage = birthdayAlert(forPass: pass)
        if !birthDayMessage.isEmpty {
            print(birthDayMessage)
        }
    }
    
    func birthdayAlert(forPass pass: Passable) -> AccessMessage {
        guard pass.entrant is AgeVerifiable && pass.entrant is GuestType else { return "" }
        switch pass.entrant as! GuestType {
        case .classic, .vip: return ""
        case .child(birthdate: let birthday):
            let isMatch = isBirthday(forPass: pass, withDate: birthday)
            return isMatch ? "Happy Birthday!" : ""
        default:
            return ""
        }
    }
    
    // Compare Date with Birthdate
    private func isBirthday(forPass pass: Passable, withDate date: Birthdate) -> Bool {
        let accessPass = pass as! AccessPassGenerator.AccessPass
        let formatter = accessPass.dateFormatter
        let todaysDate = formatter.string(from: Date())
        let index: String.Index = date.index(date.startIndex, offsetBy: 5)
        
        guard date.substring(from: index) == todaysDate.substring(from: index) else { return false }
        
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
