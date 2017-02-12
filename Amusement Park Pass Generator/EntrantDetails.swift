//
//  EntrantDetails.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

protocol Contactable {
    var contactInformation: EntrantDetails { get }
}

struct EntrantDetails {
    fileprivate (set) var firstName: String?
    fileprivate (set) var lastName: String?
    fileprivate (set) var streetAddress: String?
    fileprivate (set) var city: String?
    fileprivate (set) var state: String?
    fileprivate (set) var zipCode: String?
    
    init(firstName: String?, lastName: String?, streetAddress: String?, city: String?, state: String?, zipCode: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

// Returns Contact Details
extension Contactable {
    var contactDetails: String {
        let firstName = contactInformation.firstName
        let lastName = contactInformation.lastName
        let streetAddress = contactInformation.streetAddress
        let city = contactInformation.city
        let state = contactInformation.state
        let zipCode = contactInformation.zipCode
        
        return "\(firstName) \(lastName) lives at \(streetAddress) in \(city) of \(state), \(zipCode)"
    }
}
