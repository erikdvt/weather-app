//
//  DateExtension.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/25.
//

import Foundation

extension Date {
    var dayofTheWeek: [String] {
        let tomorrowNumber = Calendar.current.component(.weekday, from: self)
        let fiveDayNumber = (tomorrowNumber + 4) % 7
        if tomorrowNumber > fiveDayNumber {
            let firstDays = daysOfTheWeek[tomorrowNumber...6]
            let lastDays = daysOfTheWeek[0...fiveDayNumber]
            
            return Array(firstDays + lastDays)
        } else {
            return Array(daysOfTheWeek[tomorrowNumber...fiveDayNumber])
        }
    }

    private var daysOfTheWeek: [String] {
        return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thurday", "Friday", "Saturday"]
    }
}
