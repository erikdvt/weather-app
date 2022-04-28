//
//  FormattedForecast.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/24.
//

import Foundation

struct FormattedForecast {
    var weather: [WeatherFor]
    var today: Date
    
    init() {
        self.weather = []
        self.today = Date()
    }
}

struct WeatherFor {
    var temp: String
    var condition: Condition
    
    init(temp: Double, id: Int) {
        self.temp = temp.toString()
        self.condition = ConditionClassifier.classifyCondition(by: id)
    }
}
