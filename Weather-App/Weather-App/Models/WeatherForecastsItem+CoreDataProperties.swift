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

    @NSManaged public var today: Date?
    @NSManaged public var t1: String?
    @NSManaged public var t2: String?
    @NSManaged public var t3: String?
    @NSManaged public var t4: String?
    @NSManaged public var t5: String?
    @NSManaged public var c1: String?
    @NSManaged public var c2: String?
    @NSManaged public var c3: String?
    @NSManaged public var c4: String?
    @NSManaged public var c5: String?

}

extension WeatherForecastsItem : Identifiable {

}
