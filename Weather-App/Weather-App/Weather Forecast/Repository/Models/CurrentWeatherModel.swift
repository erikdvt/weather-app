//
//  CurrentWeatherModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

// MARK: - CurrentWeatherModel
struct CurrentWeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let id: Int
    let name: String
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
}
