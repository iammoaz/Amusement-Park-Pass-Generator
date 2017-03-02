//
//  Date.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

// Calculates age in seconds from the number
extension Int {
    var inSeconds: TimeInterval {
        return TimeInterval(60 * 60 * 24 * 365.2422 * Double(self))
    }
}

// Constructs a date using the components specified
extension Date {
    static func getDateFrom(year: Int, month: Int, Day: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = Day
        
        return calendar.date(from: components)
    }
    
    static func getDateFromString(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: stringDate)
        return date
    }
}
