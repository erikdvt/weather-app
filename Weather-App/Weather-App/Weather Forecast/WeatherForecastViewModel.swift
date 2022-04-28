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

class WeatherForecastViewModel: NSObject {
    
    private weak var delegate: WeatherForecastViewModelDelegate?
    private var repository: WeatherForecastRepositoryType
    var coreDataRepo: FavouriteWeatherForecastsRepositoryType?
    private let locationManager = CLLocationManager()
    private var weather: CurrentWeatherModel?
    private var forecast: FiveDayForecastModel?
    private var formattedCurrent = FormattedCurrent(0.0, 0.0, 0.0, 800, "City")
    private var formattedForecast = FormattedForecast()
    private var theme: Theme = Theme.forest
    public var favouriteLocations: [FavLocation]? = []
    public var coordinatesT = Coord(lon: -33.9249, lat: 18.4241)
    public var seguedTo: Bool = false
    
    init(delegate: WeatherForecastViewModelDelegate?,
         repository: WeatherForecastRepositoryType,
         coreDataRepo: FavouriteWeatherForecastsRepositoryType) {
        self.delegate = delegate
        self.repository = repository
        self.coreDataRepo = coreDataRepo
    }
    
    public func getDaysOfTheWeek() {
        let days = Date().dayofTheWeek
        delegate?.displayDays(days)
    }
    
    public func getLocation() {
        fetchLocationData()
    }
    
    public func attemptSaveLocation() {
        self.coreDataRepo?.saveFavourite(coordinates: self.coordinatesT, cityName: formattedCurrent.city)
    }
    
    public func flipTheme() {
        switch theme {
        case .forest:
            theme = .sea
        case .sea:
            theme = .forest
        }
        changeBackground()
    }

    public func fetchWeather() {
        repository.fetchCurrentWeather(coordinates: coordinatesT, completion: { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather = weather
                self?.formatCurrent()
                guard let safeWeatherItem = self?.formattedCurrent else {return}
                self?.showWeather(safeFormattedCurrent: safeWeatherItem)
                
            case .failure(let error):
                
                switch error {
                case .invalidData:
                    self?.delegate?.showError("Internet error")
                case .invalidResponse:
                    self?.delegate?.showError(error.rawValue)
                case .invalidRequest:
                    self?.delegate?.showError(error.rawValue)
                case .invalidUrl:
                    self?.delegate?.showError(error.rawValue)
                case .parsingError:
                    self?.delegate?.showError(error.rawValue)
                case .internalError:
                    self?.delegate?.showError(error.rawValue)
                }
                
                self?.delegate?.showError(error.rawValue)
            }
        })
    }
    
    public func fetchForecast() {
        repository.fetchFiveDayForecast(coordinates: coordinatesT, completion: { [weak self] result in
            switch result {
            case .success(let weather):
                self?.forecast = weather
                self?.formatForecast()
                self?.showForecast()
            case .failure(let error):
                self?.delegate?.showError(error.rawValue)
            }
        })
    }
    
    private func formatCurrent() {
        let currentTemp: Double = weather?.main.temp ?? 0.0
        let minTemp: Double = weather?.main.tempMin ?? 0.0
        let maxTemp: Double = weather?.main.tempMax ?? 0.0
        let city: String = weather?.name ?? "City"
        let id: Int = weather?.weather[0].id ?? 0
        
        formattedCurrent = FormattedCurrent(currentTemp, minTemp, maxTemp, id, city)
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
    
    private func showWeather(safeFormattedCurrent: FormattedCurrent) {
        delegate?.displayCurrent(safeFormattedCurrent)
        changeBackground()
    }
    
    private func showForecast() {
        delegate?.displayForecast(formattedForecast)
        changeBackground()
    }
    
    private func changeBackground() {
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
                delegate?.reloadBackground(colour: "SunnySea", image: "sea_sunny")
            case .cloudy:
                delegate?.reloadBackground(colour: "Cloudy", image: "sea_cloudy")
            case .rainy:
                delegate?.reloadBackground(colour: "Rainy", image: "sea_rainy")
            }
        }
    }
}

extension WeatherForecastViewModel: CLLocationManagerDelegate {
    
    func fetchLocationData() {
        if seguedTo {
            fetchWeather()
            fetchForecast()
        } else {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinatesT = Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
            fetchWeather()
            fetchForecast()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

enum Theme {
    case forest
    case sea
}
