//
//  FormattedCurrent.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/24.
//

import Foundation

struct FormattedCurrent {
    var currentTemp: String
    var minTemp: String
    var maxTemp: String
    var condition: Condition
    var city: String
    var today: Date
    
    init(_ curT: Double, _ minT: Double, _ maxT: Double, _ id: Int, _ city: String) {
        self.currentTemp = curT.toString()
        self.minTemp = minT.toString()
        self.maxTemp = maxT.toString()
        self.city = city
        self.condition = ConditionClassifier.classifyCondition(by: id)
        self.today = Date()
    }
}
