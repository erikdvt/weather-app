//
//  FormattedForecast.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/24.
//

import Foundation

struct FormattedForecast {
    var weather: [WeatherFor]
    
    init() {
        self.weather = []
    }
}

struct WeatherFor {
    let temp: String
    let condition: Condition
    
    init(temp: Double, id: Int) {
        self.temp = temp.toString()
        self.condition = ConditionClassifier.classifyCondition(by: id)
    }
}
