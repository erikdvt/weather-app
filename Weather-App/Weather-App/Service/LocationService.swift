//
//  LocationService.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/26.
//

import Foundation
import CoreLocation

protocol LocationServiceType {
    func fetchLocationData()
}

class LocationService: NSObject, LocationServiceType {
    private let locationManager = CLLocationManager()
    static let shared = LocationService()
    var coordinates: Coord = Coord(lon: 0.0, lat: 0.0)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchLocationData(){
        
        //LocationService.shared.locationManager.requestLocation()
        
        LocationService.shared.locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("gotten location")
        
        if let location = locations.first {
            coordinates = Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
            print(coordinates)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
