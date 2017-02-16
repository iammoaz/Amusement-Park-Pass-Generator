//
//  Employee.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/10/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

fileprivate let employeeFoodDiscount: Percentage = 15
fileprivate let employeeMerchandiseDicount: Percentage = 25

enum EmployeeType: Entrant, Contactable {
    case foodServices(EntrantDetails)
    case rideServices(EntrantDetails)
    case maintenance(EntrantDetails)
}

extension EmployeeType {
    var accessAreas: [AccessArea] {
        switch self {
            case .foodServices:
                return [.amusement, .kitchen]
            case .maintenance:
                return [.amusement, .kitchen, .rideControl, .maintenance]
            case .rideServices:
                return [.amusement, .rideControl]
        }
    }
    
    var discounts: (food: Percentage, merchandise: Percentage) {
        return (employeeFoodDiscount, employeeMerchandiseDicount)
    }
    
    var contactInformation: EntrantDetails? {
        switch self {
            case .foodServices(let details):
                return details
            case .maintenance(let details):
                return details
            case .rideServices(let details):
                return details
        }
    }
}
