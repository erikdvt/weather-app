//
//  FavouriteWeatherForecastsViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation

protocol FavouriteWeatherForecastsViewModelDelegate: AnyObject {
    func reloadView()
    func showError(_ error: String)
}

class FavouriteWeatherForecastsViewModel {
    private weak var delegate: FavouriteWeatherForecastsViewModelDelegate?
    private var repository: FavouriteWeatherForecastsRepositoryType
    public var cities: [FavLocation] = []
    
    init(delegate: FavouriteWeatherForecastsViewModelDelegate?, repository: FavouriteWeatherForecastsRepositoryType) {
        self.delegate = delegate
        self.repository = repository
    }
    
    public func displayCities() {
        repository.fetchFavourites(completion: {[weak self] result in
                switch result {
                case .success(let data):
                    self?.cities = data
                    self?.delegate?.reloadView()
                case .failure(let error):
                    self?.delegate?.showError(error.rawValue)
                }
        })
    }
    
    public var cityCount: Int {
        return cities.count
    }
    
    public func setCities(newCities: [FavLocation]?) {
        guard let safeNewCities = newCities else { return }
        cities = safeNewCities
    }
}
