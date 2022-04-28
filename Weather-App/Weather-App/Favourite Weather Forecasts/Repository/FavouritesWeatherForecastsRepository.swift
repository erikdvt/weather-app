//
//  FavouritesWeatherForecastsRepository.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation
import UIKit

typealias CurrentWeatherDataResult = (Result<[CurrentWeatherItem], CustomError>) -> Void

protocol FavouriteWeatherForecastsRepositoryType {
    func fetchWeather(completion: @escaping(CurrentWeatherDataResult))
    func saveWeather(temp: String)
}

class FavouriteWeatherForecastsRepository: FavouriteWeatherForecastsRepositoryType {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var weatherItems: [CurrentWeatherItem]? = []
    
    func fetchWeather(completion: @escaping(CurrentWeatherDataResult)) {
        do {
            self.weatherItems = try context?.fetch(CurrentWeatherItem.fetchRequest())
            DispatchQueue.main.async {
                print( self.weatherItems ?? "No items" )
                guard let safeWeatherItems = self.weatherItems else {return}
                completion(.success(safeWeatherItems))
            }
        } catch {
            completion(.failure(.internalError))
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
