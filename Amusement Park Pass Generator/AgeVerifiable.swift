//
//  AgeVerifiable.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

typealias Birthdate = String

// Protocol for verifying birthday
protocol AgeVerifiable {
    var dateFormatter: DateFormatter { get }
    func years(fromSeconds seconds: TimeInterval) -> TimeInterval
    func birthdate(dateString: String, meetsRequirement age: Double) throws -> Bool
}

extension AgeVerifiable {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }
    
    func years(fromSeconds seconds: TimeInterval) -> TimeInterval {
        let numSecInYear = 1.inSeconds
        return seconds / numSecInYear
    }
    
    func birthdate(dateString: Birthdate, meetsRequirement age: Double) throws -> Bool {
        // Current Date
        let today = Date()
        
        guard let birthdate = Date.getDateFromString(stringDate: dateString) else {
            throw PassError.invalidDateFormat(message: "Please enter date in format \"MM/dd/yyyy\"")
        }
        
        // Number of seconds since give date
        let timeInterval = today.timeIntervalSince(birthdate)
        
        // Number of years from seconds
        let entrantAge = years(fromSeconds: timeInterval)
        
        // Check child entrant age is under free child threshold
        guard entrantAge < age else {
            throw PassError.failsChildAgeRequirement(message: "Child does not meet age requirements for a free child pass\nPass converted to Classic Pass")
        }
        
        return years(fromSeconds: timeInterval) < age
    }
}
