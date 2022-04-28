//
//  Weather_AppTests.swift
//  Weather-AppTests
//
//  Created by Erik Egers on 2022/04/21.
//

import XCTest
@testable import Weather_App

class Weather_AppTests: XCTestCase {

    private var viewModel: WeatherForecastViewModel!
    private var mDelegate: MockDelegate!
    private var repository: MockRepository!
    private var coreDataRepo: MockCoreDataRepo!
    
    override func setUp() {
        super.setUp()
        mDelegate = MockDelegate()
        repository = MockRepository()
        coreDataRepo = MockCoreDataRepo()
        viewModel = WeatherForecastViewModel(delegate: mDelegate, repository: repository, coreDataRepo: coreDataRepo)
    }
    
    func testFetchCurrentWeatherReturnsSuccess() {
        viewModel.fetchWeather()
        XCTAssertTrue(mDelegate.displayCurrentCalled)
    }
    
    func testFetchCurrentWeatherReturnsFailure() {
        repository.shouldFail = true
        viewModel.fetchWeather()
        XCTAssertTrue(mDelegate.showErrorCalled)
    }
    
    func testFetchCurrentWeatherReturnsCorrectResult() {
        viewModel.fetchWeather()
        let result = mDelegate.current
        XCTAssertEqual(result.currentTemp, "10°")
        XCTAssertEqual(result.minTemp, "9°")
        XCTAssertEqual(result.maxTemp, "12°")
        XCTAssertEqual(result.condition.rawValue, "cloudy")
        XCTAssertEqual(result.city, "Amsterdam")
    }
    
    func testFetchWeatherForecastReturnsSuccess() {
        viewModel.fetchForecast()
        XCTAssertTrue(mDelegate.displayForecastCalled)
    }
    
    func testattemptSaveLocationCallsSaveFavourite() {
        viewModel.fetchWeather()
        viewModel.fetchForecast()
        viewModel.attemptSaveLocation()
        XCTAssertTrue(coreDataRepo.saveFavCalled)
    }
    
    func testFlipThemeCausesBackgroundReload() {
        viewModel.flipTheme()
        viewModel.flipTheme()
        XCTAssertTrue(mDelegate.reloadBackgroundCalled)
    }
}

class MockRepository: WeatherForecastRepositoryType {
    var shouldFail = false
    
    func fetchFiveDayForecast(coordinates: Coord, completion: @escaping ((Result<FiveDayForecastModel, CustomError>) -> Void)) {
        if shouldFail {
            completion(.failure(.internalError))
        } else {
            completion(.success(self.mockForecastData()))
        }
    }
    
    func fetchCurrentWeather(coordinates: Coord, completion: @escaping ((Result<CurrentWeatherModel, CustomError>) -> Void)) {
        if shouldFail {
            completion(.failure(.internalError))
        } else {
            completion(.success(self.mockCurrentData()))
        }
    }
    
    private func mockCurrentData() -> CurrentWeatherModel {
        let mockData: CurrentWeatherModel = CurrentWeatherModel(coord: Coord(lon: 4.9041, lat: 52.3676),
                                                                weather: [Weather(id: 803)],
                                                                main: Main(temp: 10.37, tempMin: 8.83, tempMax: 11.63),
                                                                id: 2759794, name: "Amsterdam")
        return mockData
    }
    
    private func mockForecastData() -> FiveDayForecastModel {
        let mockData = FiveDayForecastModel(list: [List(main: Mainf(temp: 9.93), weather: [Weatherf(id: 803)]),
                                                   List(main: Mainf(temp: 8.88), weather: [Weatherf(id: 804)]),
                                                   List(main: Mainf(temp: 7.91), weather: [Weatherf(id: 804)]),
                                                   List(main: Mainf(temp: 6.74), weather: [Weatherf(id: 803)]),
                                                   List(main: Mainf(temp: 7.93), weather: [Weatherf(id: 802)])],
                                            city: City(id: 2759794,
                                                       name: "Amsterdam",
                                                       coord: Coordf(lat: 52.3676, lon: 4.9041)))
        return mockData
    }
}

class MockDelegate: WeatherForecastViewModelDelegate {
    var showErrorCalled = false
    var displayDaysCalled = false
    var displayCurrentCalled = false
    var displayForecastCalled = false
    var reloadBackgroundCalled = false
    
    var current: FormattedCurrent = FormattedCurrent(0.0, 0.0, 0.0, 800, "City")
    
    func showError(_ error: String) {
        showErrorCalled = true
    }
    func displayDays(_ days: [String]) {
        displayDaysCalled  = true
    }
    func displayCurrent(_ formattedData: FormattedCurrent) {
        displayCurrentCalled  = true
        current = formattedData
    }
    func displayForecast(_ formattedData: FormattedForecast) {
        displayForecastCalled = true
    }
    func reloadBackground(colour: String, image: String) {
        reloadBackgroundCalled = true
    }
}

class MockCoreDataRepo: FavouriteWeatherForecastsRepositoryType {
    var saveFavCalled = false
    
    func saveFavourite(coordinates: Coord, cityName: String) {
        saveFavCalled = true
    }
    func fetchFavourites(completion: @escaping(FavouriteLocationResult)) {
        
    }
}
