//
//  WeatherForecastsItem+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/28.
//
//

import Foundation
import CoreData

extension WeatherForecastsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecastsItem> {
        return NSFetchRequest<WeatherForecastsItem>(entityName: "WeatherForecastsItem")
    }

    @NSManaged public var lastLocation: LastLocation?

}

extension WeatherForecastsItem : Identifiable {

}
