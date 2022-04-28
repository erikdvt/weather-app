//
//  FavouriteWeatherForecastsTests.swift
//  Weather-AppTests
//
//  Created by Erik Egers on 2022/04/28.
//

import XCTest
@testable import Weather_App

class FavouriteWeatherForecastsTests: XCTestCase {

    private var viewModel: FavouriteWeatherForecastsViewModel!
    private var mDelegate: FavMockDelegate!
    private var coreDataRepo: FavMockCoreDataRepo!
    
    override func setUp() {
        super.setUp()
        mDelegate = FavMockDelegate()
        coreDataRepo = FavMockCoreDataRepo()
        viewModel = FavouriteWeatherForecastsViewModel(delegate: mDelegate, repository: coreDataRepo)
    }
    
    func testDisplayCitiesReturnsSuccess() {
        viewModel.displayCities()
        XCTAssertTrue(mDelegate.reloadViewCalled)
    }
    
    func testDisplayCitiesReturnsFailure() {
        coreDataRepo.shouldFail = true
        viewModel.displayCities()
        XCTAssertTrue(mDelegate.showErrorCalled)
    }
    
    func testCityCountReturnsCorrectNumber() {
        viewModel.displayCities()
        XCTAssertEqual(viewModel.cityCount, 2)
    }
}

class FavMockDelegate: FavouriteWeatherForecastsViewModelDelegate {
    var reloadViewCalled = false
    var showErrorCalled = false
    
    func reloadView() {
        reloadViewCalled = true
    }
    
    func showError(_ error: String) {
        showErrorCalled = true
    }
    
}

class FavMockCoreDataRepo: FavouriteWeatherForecastsRepositoryType {
    func saveLastCurrent(data: FormattedCurrent) {
        
    }
    
    func fetchLastCurrent(completion: @escaping (LastCurrentResult)) {
        
    }
    
    func saveLastForecast(data: FormattedForecast) {
        
    }
    
    func fetchLastForecast(completion: @escaping (LastForecastResult)) {
        
    }
    
    var shouldFail = false
    var saveFavCalled = false
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    func saveFavourite(coordinates: Coord, cityName: String) {
        saveFavCalled = true
    }
    func fetchFavourites(completion: @escaping(FavouriteLocationResult)) {
        if shouldFail {
            completion(.failure(.internalError))
        } else {
            completion(.success(self.mockData()))
        }
    }
    
    private func mockData() -> [FavLocation] {
        
        var favLocations: [FavLocation] = []
        
        let loc1 = FavLocation(context: context!)
        loc1.lat = 2.2
        loc1.lon = 1.2
        loc1.city = "City Name1"
        
        let loc2 = FavLocation(context: context!)
        loc2.lat = 2.3
        loc2.lon = 1.1
        loc2.city = "City Name2"
        
        favLocations = [loc1, loc2]
        
        return favLocations
    }
}
