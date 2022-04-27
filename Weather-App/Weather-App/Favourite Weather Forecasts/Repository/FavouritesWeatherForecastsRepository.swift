//
//  FavouritesWeatherForecastsRepository.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation
import UIKit

protocol FavouriteWeatherForecastsRepositoryType {
    func fetchWeather()
    func saveWeather(temp: String)
}

class FavouriteWeatherForecastsRepository: FavouriteWeatherForecastsRepositoryType {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var weatherItems: [CurrentWeatherItem]? = []
    
    func fetchWeather() {
        do {
            self.weatherItems = try context?.fetch(CurrentWeatherItem.fetchRequest())
            DispatchQueue.main.async {
                print( self.weatherItems ?? "No items" )
            }
        } catch {
            
        }
    }
    
    func saveWeather(temp: String) {
        guard let safeContext = self.context else { return }
        let newWeather = CurrentWeatherItem(context: safeContext)
        newWeather.temp = temp
        
        do {
            try safeContext.save()
        } catch {
            
        }
    }
}
