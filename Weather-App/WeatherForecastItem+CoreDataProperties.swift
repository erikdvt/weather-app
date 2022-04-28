//
//  WeatherForecastItem+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/28.
//
//

import Foundation
import CoreData


extension WeatherForecastItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecastItem> {
        return NSFetchRequest<WeatherForecastItem>(entityName: "WeatherForecastItem")
    }

    @NSManaged public var conditionRaw: String?
    @NSManaged public var temp: String?
    @NSManaged public var weatherForecasts: WeatherForecastsItem?

}

extension WeatherForecastItem : Identifiable {

}
