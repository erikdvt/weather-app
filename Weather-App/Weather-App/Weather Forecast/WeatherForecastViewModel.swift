//
//  ViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

protocol WeatherForecastViewModelDelegate: AnyObject {
    func showError(_ error: String)
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
    
    func fetchWeather() {
        repository.fetchCurrentWeather(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    //self?.delegate?.reloadView()
                    print(self?.currentWeather ?? "")
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
                    //self?.delegate?.reloadView()
                    print(self?.forecast ?? "")
                case .failure(let error):
                    self?.delegate?.showError(error.rawValue)
                }
            }
        })
    }
}
