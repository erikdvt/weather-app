//
//  CurrentWeatherItem+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//
//

import Foundation
import CoreData


extension CurrentWeatherItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherItem> {
        return NSFetchRequest<CurrentWeatherItem>(entityName: "CurrentWeatherItem")
    }

    @NSManaged public var temp: String?

}

extension CurrentWeatherItem : Identifiable {

}
