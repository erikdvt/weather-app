//
//  FormattedCurrent.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/24.
//

import Foundation

struct FormattedCurrent {
    let currentTemp: String
    let minTemp: String
    let maxTemp: String
    let condition: Condition
    
    init(_ curT: Double, _ minT: Double, _ maxT: Double, _ id: Int) {
        self.currentTemp = curT.toString()
        self.minTemp = minT.toString()
        self.maxTemp = maxT.toString()
        self.condition = ConditionClassifier.classifyCondition(by: id)
    }
}
