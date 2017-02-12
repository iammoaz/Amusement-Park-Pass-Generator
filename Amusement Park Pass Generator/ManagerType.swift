//
//  Manager.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

fileprivate let managerFoodDiscount: Percentage = 25
fileprivate let managerMerchandiseDiscount: Percentage = 25

// Enum to hold Manager types i.e shift, senior, general
enum ManagerType: Entrant, Contactable {
    case manager(EntrantDetails)
}

extension ManagerType {
    var discounts: (food: Percentage, merchandise: Percentage) {
        let foodDiscount = DiscountType.food(managerFoodDiscount).percentage
        let merchandiseDiscount = DiscountType.merchandise(managerMerchandiseDiscount).percentage
        return (foodDiscount, merchandiseDiscount)
    }
    
    var accessAreas: [AccessArea] {
        return [.amusement, .kitchen, .maintenance, .rideControl, .office]
    }
    
    var contactInformation: EntrantDetails {
        switch self {
            case .manager(let details): return details
        }
    }
}
