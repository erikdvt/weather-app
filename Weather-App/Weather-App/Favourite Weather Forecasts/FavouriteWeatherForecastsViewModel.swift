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
    
    init(delegate: FavouriteWeatherForecastsViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func displayCities() {
        self.delegate?.reloadView()
    }
    
    var cityCount: Int = 2
    var cities: [String] = ["Cape Town", "Johannesburg"]
}
