//
//  Constants.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

struct Constants {
    static let apiKey = "8a41a2fe4fe39f5dc84331706a8c1d45"
    static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)"
    static let fiveDayForecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=\(apiKey)&cnt=5"
}
