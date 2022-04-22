//
//  WeatherForecastModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

// MARK: - Welcome
struct FiveDayForecastModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordf
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coordf: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Mainf
    let weather: [Weatherf]
    let clouds: Cloudsf
    let wind: Windf
    let visibility, pop: Int
    let sys: Sysf
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Cloudsf: Codable {
    let all: Int
}

// MARK: - Main
struct Mainf: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct Sysf: Codable {
    let pod: String
}

// MARK: - Weather
struct Weatherf: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Windf: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
