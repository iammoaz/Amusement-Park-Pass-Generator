//
//  Data.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/27/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

struct Data {
    static let name = EntrantName(firstName: "Muhammad", lastName: "Moaz")
    static let birthdate = EntrantBirthdate(dateOfBirth: "11/29/1991")
    static let address = EntrantAddress(street: "Al Shuhada Street", city: "Sharq", state: "Kuwait City", zipCode: "13700")
    static let visidate = EntrantVisitDate(dateOfVisit: "02/27/2017")
    static let socialSecurityNumber = EntrantSocialSecurityNumber(socialSecurityNumber: "00000000000")
}
