//
//  DiscountType.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/10/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

typealias Percentage = Int

enum DiscountType {
    case food(Percentage)
    case merchandise(Percentage)
}

extension DiscountType {
    var percentage: Percentage {
        switch self {
            case .food(let percentage):
                return percentage
            case .merchandise(let percentage):
                return percentage
        }
    }
}
