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
}

class WeatherForecastViewModel {
    
    private var currentWeather: CurrentWeatherModel?
    private var forecast: FiveDayForecastModel?
    private weak var delegate: WeatherForecastViewModelDelegate?
    private var repository: WeatherForecastRepositoryType
    
    init(delegate: WeatherForecastViewModelDelegate?,
         repository: WeatherForecastRepositoryType) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getDaysOfTheWeek() {
        let days = Date().dayofTheWeek
        print(days)
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
        guard let description: String = currentWeather?.weather[0].weatherDescription else { return }
        
        let formattedData = FormattedCurrent(currentTemp, minTemp, maxTemp, description)
        
        delegate?.displayCurrent(formattedData)
    }
    
    func formatForecast() {
        var formattedData = FormattedForecast()
        guard let weatherList: [List] = forecast?.list else { return }
        
        for weatherItem in weatherList {
            let weatherI = WeatherFor(weatherItem.main.temp, weatherItem.weather[0].weatherDescription)
            formattedData.weather.append(weatherI)
        }
        
        delegate?.displayForecast(formattedData)
        
    }
}
