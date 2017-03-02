//
//  EntrantDetails.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

protocol Nameable {
    var name: EntrantName? { get }
}

protocol Addressable {
    var address: EntrantAddress { get }
}

protocol BirthDateable {
    var birthdate: EntrantBirthdate { get }
}

protocol VisitDateable {
    var visitdate: EntrantVisitDate { get }
}

protocol Securable {
    var socialSecurityNumber: EntrantSocialSecurityNumber { get }
}

struct EntrantName {
    fileprivate (set) var firstName: String?
    fileprivate (set) var lastName: String?
    
    init(firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct EntrantAddress {
    fileprivate (set) var street: String?
    fileprivate (set) var city: String?
    fileprivate (set) var state: String?
    fileprivate (set) var zipCode: String?
    
    init(street: String?, city: String?, state: String?, zipCode: String?) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

struct EntrantBirthdate {
    fileprivate (set) var dateOfBirth: Birthdate
    
    init(dateOfBirth: Birthdate) {
        self.dateOfBirth = dateOfBirth
    }
}

struct EntrantVisitDate {
    fileprivate (set) var dateOfVisit: String?
    
    init(dateOfVisit: String?) {
        self.dateOfVisit = dateOfVisit
    }
}

struct EntrantSocialSecurityNumber {
    fileprivate (set) var socialSecurityNumber: String?
    
    init(socialSecurityNumber: String?) {
        self.socialSecurityNumber = socialSecurityNumber
    }
}

// Returns Address Details
extension Addressable {
    var addressDetails: String {
        let street = address.street
        let city = address.city
        let state = address.state
        let zipCode = address.zipCode
        
        return "\(street) in \(city) of \(state), \(zipCode)"
    }
}
