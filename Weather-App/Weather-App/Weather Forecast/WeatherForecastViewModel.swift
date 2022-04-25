//
//  ViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

protocol WeatherForecastViewModelDelegate: AnyObject {
    func showError(_ error: String)
    func displayDays(_ days: [String])
    func displayCurrent(_ formattedData: FormattedCurrent)
    func displayForecast(_ formattedData: FormattedForecast)
    func reloadBackground(colour: String, image: String)
}

class WeatherForecastViewModel {
    
    private var currentWeather: CurrentWeatherModel?
    private var forecast: FiveDayForecastModel?
    private weak var delegate: WeatherForecastViewModelDelegate?
    private var repository: WeatherForecastRepositoryType
    private var theme: Theme = Theme.forest
    private var currentCondition: Condition = Condition.sunny
    
    init(delegate: WeatherForecastViewModelDelegate?,
         repository: WeatherForecastRepositoryType) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getDaysOfTheWeek() {
        let days = Date().dayofTheWeek
        delegate?.displayDays(days)
    }
    
    func fetchWeather() {
        repository.fetchCurrentWeather(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    self?.formatCurrent()
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
                case .failure(let error):
                    self?.delegate?.showError(error.rawValue)
                }
            }
        })
    }
    
    func formatCurrent() {
        guard let currentTemp: Double = currentWeather?.main.temp else { return }
        guard let minTemp: Double = currentWeather?.main.tempMin else { return }
        guard let maxTemp: Double = currentWeather?.main.tempMax else { return }
        guard let id: Int = currentWeather?.weather[0].id else { return }
        
        let formattedData = FormattedCurrent(currentTemp, minTemp, maxTemp, id)
        currentCondition = formattedData.condition
        
        delegate?.displayCurrent(formattedData)
        changeBackground()
    }
    
    func formatForecast() {
        var formattedData = FormattedForecast()
        guard let weatherList: [List] = forecast?.list else { return }
        
        for weatherItem in weatherList {
            let weatherI = WeatherFor(temp: weatherItem.main.temp, id: weatherItem.weather[0].id)
            formattedData.weather.append(weatherI)
        }
        
        delegate?.displayForecast(formattedData)
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
