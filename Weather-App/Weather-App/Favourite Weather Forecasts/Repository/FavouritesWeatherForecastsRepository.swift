//
//  FavouritesWeatherForecastsRepository.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation
import UIKit

typealias FavouriteLocationResult = (Result<[FavLocation], CustomError>) -> Void

protocol FavouriteWeatherForecastsRepositoryType {
    func saveFavourite(coordinates: Coord, cityName: String)
    func fetchFavourites(completion: @escaping(FavouriteLocationResult))
}

class FavouriteWeatherForecastsRepository: FavouriteWeatherForecastsRepositoryType {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var favLocations: [FavLocation]? = []
    
    func saveFavourite(coordinates: Coord, cityName: String) {
        guard let safeContext = self.context else { return }
        let newFav = FavLocation(context: safeContext)
        newFav.city = cityName
        newFav.lat = coordinates.lat
        newFav.lon = coordinates.lon
        do {
            try safeContext.save()
        } catch {
            print("error saving")
        }
    }
    
    func fetchFavourites(completion: @escaping(FavouriteLocationResult)) {
        do {
            self.favLocations = try context?.fetch(FavLocation.fetchRequest())
            DispatchQueue.main.async {
                print( self.favLocations ?? "No items" )
                guard let safeWeatherLocations = self.favLocations else {return}
                completion(.success(safeWeatherLocations))
            }
        } catch {
            DispatchQueue.main.async { completion(.failure(.internalError)) }
        }
    }
}
