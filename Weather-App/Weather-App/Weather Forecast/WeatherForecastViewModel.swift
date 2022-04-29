//
//  ViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation
import CoreLocation

protocol WeatherForecastViewModelDelegate: AnyObject {
    func showError(title: String, error: String)
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
    public var isOnline: ConnectionStatus = .offline
    
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
    
    public func getTheWeather() {
        if ConnectionManager.isConnectedToNetwork() {
            isOnline = .online
            fetchLocationData()
        } else {
            isOnline = .offline
            self.coreDataRepo?.fetchLastCurrent(completion: { result in
                switch result {
                case .success(let data):
                    
                    if !data.isEmpty {
                        self.formattedCurrent.today = data[0].today ?? Date()
                        self.formattedCurrent.currentTemp = data[0].currentTemp ?? "nil"
                        self.formattedCurrent.minTemp = data[0].minTemp ?? "nil"
                        self.formattedCurrent.maxTemp = data[0].maxTemp ?? "nil"
                        self.formattedCurrent.city = data[0].city ?? "nil"
                        self.formattedCurrent.condition = Condition(rawValue: data[0].conditionRaw ?? "sunny") ?? .sunny
                        
                        self.showWeather(safeFormattedCurrent: self.formattedCurrent)
                    } else {
                        self.delegate?.showError(title: "Cached weather error", error: "Connect internet and try again")
                    }
                    
                    

                case .failure(let error):
                    self.delegate?.showError(title: "Cached weather error", error: error.rawValue)
                }
            })
            
            self.coreDataRepo?.fetchLastForecast(completion: { result in
                switch result {
                case .success(let data):
                    
                    if !data.isEmpty {
                        var w1 = WeatherFor(temp: 0, id: 800)
                        var w2 = WeatherFor(temp: 0, id: 800)
                        var w3 = WeatherFor(temp: 0, id: 800)
                        var w4 = WeatherFor(temp: 0, id: 800)
                        var w5 = WeatherFor(temp: 0, id: 800)
                        
                        w1.temp = data[0].t1 ?? "0"
                        w1.condition = Condition(rawValue: data[0].c1 ?? "sunny") ?? .sunny
                        w2.temp = data[0].t2 ?? "0"
                        w2.condition = Condition(rawValue: data[0].c2 ?? "sunny") ?? .sunny
                        w3.temp = data[0].t3 ?? "0"
                        w3.condition = Condition(rawValue: data[0].c3 ?? "sunny") ?? .sunny
                        w4.temp = data[0].t4 ?? "0"
                        w4.condition = Condition(rawValue: data[0].c4 ?? "sunny") ?? .sunny
                        w5.temp = data[0].t5 ?? "0"
                        w5.condition = Condition(rawValue: data[0].c5 ?? "sunny") ?? .sunny
                        
                        self.formattedForecast.today = data[0].today ?? Date()
                        self.formattedForecast.weather.append(w1)
                        self.formattedForecast.weather.append(w2)
                        self.formattedForecast.weather.append(w3)
                        self.formattedForecast.weather.append(w4)
                        self.formattedForecast.weather.append(w5)
                        
                        self.showForecast(safeFormattedForecast: self.formattedForecast)
                    } else {
                        self.delegate?.showError(title: "Cached weather error", error: "Connect internet and try again")
                    }
                    
                    
                case .failure(let error):
                    self.delegate?.showError(title: "Cached weather error", error: error.rawValue)
                }
            })
        }
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
                self?.coreDataRepo?.saveLastCurrent(data: safeWeatherItem)
                self?.showWeather(safeFormattedCurrent: safeWeatherItem)
            case .failure(let error):
                self?.delegate?.showError(title: "No weather found", error: error.rawValue)
            }
        })
    }
    
    public func fetchForecast() {
        repository.fetchFiveDayForecast(coordinates: coordinatesT, completion: { [weak self] result in
            switch result {
            case .success(let weather):
                self?.forecast = weather
                self?.formatForecast()
                guard let safeForecastItem = self?.formattedForecast else { return }
                self?.coreDataRepo?.saveLastForecast(data: safeForecastItem)
                self?.showForecast(safeFormattedForecast: safeForecastItem)
            case .failure(let error):
                self?.delegate?.showError(title: "No forecasts found", error: error.rawValue)
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
    
    private func showForecast(safeFormattedForecast: FormattedForecast) {
        delegate?.displayForecast(safeFormattedForecast)
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
            case .rainny:
                delegate?.reloadBackground(colour: "Rainy", image: "forest_rainy")
            }
        case .sea:
            switch currentCondition {
            case .sunny:
                delegate?.reloadBackground(colour: "SunnySea", image: "sea_sunny")
            case .cloudy:
                delegate?.reloadBackground(colour: "Cloudy", image: "sea_cloudy")
            case .rainny:
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
        delegate?.showError(title: "No weather found", error: error.localizedDescription)
    }

}

enum Theme {
    case forest
    case sea
}

enum ConnectionStatus: String {
    case online
    case offline
}
