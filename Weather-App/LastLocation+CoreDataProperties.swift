//
//  LastLocation+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/28.
//
//

import Foundation
import CoreData

extension LastLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastLocation> {
        return NSFetchRequest<LastLocation>(entityName: "LastLocation")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var weather: CurrentWeatherItem?
    @NSManaged public var forecast: WeatherForecastsItem?

}

extension LastLocation : Identifiable {

}
