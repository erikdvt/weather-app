//
//  FavouriteWeatherForecastsViewModel.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation

protocol FavouriteWeatherForecastsViewModelDelegate: AnyObject {
    func reloadView()
}

class FavouriteWeatherForecastsViewModel {
    private weak var delegate: FavouriteWeatherForecastsViewModelDelegate?
    private var repository: FavouriteWeatherForecastsRepositoryType
    
    var cities: [FavLocation] = []
    
    init(delegate: FavouriteWeatherForecastsViewModelDelegate?, repository: FavouriteWeatherForecastsRepositoryType) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func displayCities() {
        repository.fetchFavourites(completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.cities = data
                    self?.delegate?.reloadView()
                case .failure(let error):
                    print(error)
                }
            }
        })
        
    }
    
    var cityCount: Int {
        return cities.count
    }
    
    func setCities(newCities: [FavLocation]?) {
        guard let safeNewCities = newCities else { return }
        cities = safeNewCities

    }
    
}
