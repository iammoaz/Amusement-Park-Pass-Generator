//
//  PassGenerator.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation
typealias PassID = Int

final class AccessPassGenerator {
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
    
    // Access to  Create Passes
    public func createPass(forEntrant entrant: Entrant) -> AccessPass {
        if entrant is AgeVerifiable {
            return pass(forVerifiableEntrant: entrant as! AgeVerifiable)
        }
        
        if entrant is EmployeeType {
            return AccessPass(for: entrant as! EmployeeType)
        }
        
        if entrant is ManagerType {
            return AccessPass(for: entrant as! ManagerType)
        }
        
        // Fallback - Should never get here!
        return AccessPass(for: GuestType.classic)
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
            
        default:
            return AccessPass(for: GuestType.classic)
        }
    }
}
