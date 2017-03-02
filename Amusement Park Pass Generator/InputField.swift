//
//  InputField.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/24/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

typealias Tag = Int

enum InputField: Tag {
    case firstName = 100
    case lastName = 101
    case dateOfBirth = 102
    case socialSecurityNumber = 103
    case companyName = 104
    case projectNumber = 105
    case dateOfVisit = 106
    case streetAddress = 107
    case city = 108
    case state = 109
    case zipCode = 110
}

extension InputField {
    var name: String {
        switch self {
            case .firstName:
                return "firstName"
            case .lastName:
                return "lastName"
            case .dateOfBirth:
                return "dateOfBirth"
            case .socialSecurityNumber:
                return "socialSecurityNumber"
            case .companyName:
                return "companyName"
            case .projectNumber:
                return "projectNumber"
            case .dateOfVisit:
                return "dateOfBirth"
            case .streetAddress:
                return "streetAddress"
            case .city:
                return "city"
            case .state:
                return "state"
            case .zipCode:
                return "zipCode"
        }
    }
}
