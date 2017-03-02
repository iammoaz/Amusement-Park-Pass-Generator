//
//  PassGenerator.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation
typealias PassID = Int

class AccessPassGenerator {
    static let instance = AccessPassGenerator()
    
    struct AccessPass: Passable, AgeVerifiable {
        static var currentPassID: PassID = 1
        private (set) var entrant: Entrant
        private (set) var maxChildAge: Double = 5
        private (set) var passID: PassID = AccessPass.currentPassID
        
        init(for entrant: Entrant) {
            self.entrant = entrant
            AccessPass.currentPassID += 1
        }
    }
    
    private init() { }
    
    // Access to  Create Passes
    public func createPass(forEntrant entrant: Entrant) -> (entrantPass: AccessPass, message: AccessMessage?) {
        
        if entrant is AgeVerifiable {
            return (pass(forVerifiableEntrant: entrant as! AgeVerifiable), "Success")
        }
        
        if entrant is GuestType {
            return (pass(forVerifiableEntrant: entrant as! AgeVerifiable), "Success")
        }
        
        if entrant is EmployeeType {
            return (AccessPass(for: entrant as! EmployeeType), "Success")
        }
        
        if entrant is ManagerType {
            return (AccessPass(for: entrant as! ManagerType), "Success")
        }
        
        if entrant is VendorType {
            return (AccessPass(for: entrant as! VendorType), "Success")
        }
        
        if entrant is ContractorType {
            return (AccessPass(for: entrant as! ContractorType), "Success")
        }
        
        // Fallback - Should never get here!
        return (AccessPass(for: GuestType.classic), nil)
    }
    
    // Only child pass need to be age verifiable
    private func pass(forVerifiableEntrant entrant: AgeVerifiable) -> AccessPass {
        let entrant = entrant as! GuestType
        
        switch entrant {
        case .classic:
            return AccessPass(for: GuestType.classic)
        
        case .vip:
            return AccessPass(for: GuestType.vip)
        
        case .child(birthdate: let birthdate):
            let pass = AccessPass(for: GuestType.child(birthdate: birthdate))
            if pass.isVerified {
                return pass
            } else {
                return AccessPass(for: GuestType.classic)
            }
            
        case .senior(name: let name, birthdate: let birthdate):
            return AccessPass(for: GuestType.senior(name: name, birthdate: birthdate))
            
        case .season(name: let name, address: let address, birthdate: let birthdate):
            return AccessPass(for: GuestType.season(name: name, address: address, birthdate: birthdate))
            
        }
    }
}
