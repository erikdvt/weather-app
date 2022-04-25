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
    let description: String
    
    init(_ tempD: Double, _ condition: String) {
        self.temp = tempD.toString()
        self.description = condition
    }
}
