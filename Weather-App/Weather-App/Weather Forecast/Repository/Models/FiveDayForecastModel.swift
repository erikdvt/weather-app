//
//  WeatherForecastModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

// MARK: - Welcome
struct FiveDayForecastModel: Codable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordf
}

// MARK: - Coord
struct Coordf: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let main: Mainf
    let weather: [Weatherf]
}

// MARK: - Main
struct Mainf: Codable {
    let temp: Double
}

// MARK: - Weather
struct Weatherf: Codable {
    let id: Int
}
