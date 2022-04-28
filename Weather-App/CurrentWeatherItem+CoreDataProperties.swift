//
//  CurrentWeatherItem+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/28.
//
//

import Foundation
import CoreData

extension CurrentWeatherItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherItem> {
        return NSFetchRequest<CurrentWeatherItem>(entityName: "CurrentWeatherItem")
    }

    @NSManaged public var currentTemp: String?
    @NSManaged public var minTemp: String?
    @NSManaged public var maxTemp: String?
    @NSManaged public var city: String?
    @NSManaged public var conditionRaw: String?
    @NSManaged public var lastLocation: LastLocation?

}

extension CurrentWeatherItem : Identifiable {

}
