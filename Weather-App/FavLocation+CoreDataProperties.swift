//
//  FavLocation+CoreDataProperties.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/28.
//
//

import Foundation
import CoreData


extension FavLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavLocation> {
        return NSFetchRequest<FavLocation>(entityName: "FavLocation")
    }

    @NSManaged public var city: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension FavLocation : Identifiable {

}
