//
//  ViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation
import CoreLocation

protocol WeatherForecastViewModelDelegate: AnyObject {
    func showError(_ error: String)
    func displayDays(_ days: [String])
    func displayCurrent(_ formattedData: FormattedCurrent)
    func displayForecast(_ formattedData: FormattedForecast)
    func reloadBackground(colour: String, image: String)
}

class WeatherForecastViewModel {
    
    private weak var delegate: WeatherForecastViewModelDelegate?
    private var repository: WeatherForecastRepositoryType
    private var theme: Theme = Theme.forest
    private var weather: CurrentWeatherModel?
    private var forecast: FiveDayForecastModel?
    private var formattedCurrent = FormattedCurrent(0.0, 0.0, 0.0, 800)
    private var formattedForecast = FormattedForecast()
    private let locationService: LocationServiceType
    
    init(delegate: WeatherForecastViewModelDelegate?,
         repository: WeatherForecastRepositoryType,
         locationService: LocationService) {
        self.delegate = delegate
        self.repository = repository
        self.locationService = LocationService()
    }
    
    func getDaysOfTheWeek() {
        let days = Date().dayofTheWeek
        delegate?.displayDays(days)
    }
    
    func getLocation() {
        locationService.fetchLocationData()
    }
    
    func fetchWeather() {
        repository.fetchCurrentWeather(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.formatCurrent()
                    self?.showWeather()
                case .failure(let error):
                    self?.delegate?.showError(error.rawValue)
                }
            }
        })
    }
    
    func fetchForecast() {
        repository.fetchFiveDayForecast(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.forecast = weather
                    self?.formatForecast()
                    self?.showForecast()
                case .failure(let error):
                    self?.delegate?.showError(error.rawValue)
                }
            }
        })
    }
    
    private func formatCurrent() {
        let currentTemp: Double = weather?.main.temp ?? 0.0
        let minTemp: Double = weather?.main.tempMin ?? 0.0
        let maxTemp: Double = weather?.main.tempMax ?? 0.0
        let id: Int = weather?.weather[0].id ?? 0
        
        formattedCurrent = FormattedCurrent(currentTemp, minTemp, maxTemp, id)
    }
    
    func showWeather() {
        delegate?.displayCurrent(formattedCurrent)
        changeBackground()
    }
    
    private func formatForecast() {
        var formattedData = FormattedForecast()
        guard let weatherList: [List] = forecast?.list else { return }
        
        for weatherItem in weatherList {
            let weatherI = WeatherFor(temp: weatherItem.main.temp, id: weatherItem.weather[0].id)
            formattedData.weather.append(weatherI)
        }
        
        formattedForecast = formattedData
    }
    
    func showForecast() {
        delegate?.displayForecast(formattedForecast)
        changeBackground()
    }
    
    func flipTheme() {
        switch theme {
        case .forest:
            theme = .sea
        case .sea:
            theme = .forest
        }
        
        changeBackground()
    }
    
    func changeBackground() {
        let currentCondition = formattedCurrent.condition
        switch theme {
        case .forest:
            switch currentCondition {
            case .sunny:
                delegate?.reloadBackground(colour: "Sunny", image: "forest_sunny")
            case .cloudy:
                delegate?.reloadBackground(colour: "Cloudy", image: "forest_cloudy")
            case .rainy:
                delegate?.reloadBackground(colour: "Rainy", image: "forest_rainy")
            }
        case .sea:
            switch currentCondition {
            case .sunny:
                delegate?.reloadBackground(colour: "Sunny", image: "sea_sunny")
            case .cloudy:
                delegate?.reloadBackground(colour: "Cloudy", image: "sea_cloudy")
            case .rainy:
                delegate?.reloadBackground(colour: "Rainy", image: "sea_rainy")
            }
        }
    }
}

enum Theme {
    case forest
    case sea
}
