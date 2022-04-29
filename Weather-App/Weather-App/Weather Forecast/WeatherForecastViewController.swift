//
//  ViewController.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/21.
//

import Foundation
import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    
    @IBOutlet private weak var currentConditionBackground: UIImageView!
    @IBOutlet private weak var currentCondition: UILabel!
    @IBOutlet private weak var currentTempBig: UILabel!
    @IBOutlet private weak var currentMinTemp: UILabel!
    @IBOutlet private weak var currentTemp: UILabel!
    @IBOutlet private weak var currentMaxTemp: UILabel!
    @IBOutlet private weak var forecastDayOne: UILabel!
    @IBOutlet private weak var forecastDayTwo: UILabel!
    @IBOutlet private weak var forecastDayThree: UILabel!
    @IBOutlet private weak var forecastDayFour: UILabel!
    @IBOutlet private weak var forecastDayFive: UILabel!
    @IBOutlet private weak var forecastConditionOne: UIImageView!
    @IBOutlet private weak var forecastConditionTwo: UIImageView!
    @IBOutlet private weak var forecastConditionThree: UIImageView!
    @IBOutlet private weak var forcastConditionFour: UIImageView!
    @IBOutlet private weak var forecastConditionFive: UIImageView!
    @IBOutlet private weak var forecastTempOne: UILabel!
    @IBOutlet private weak var forevastTempTwo: UILabel!
    @IBOutlet private weak var forecastTempThree: UILabel!
    @IBOutlet private weak var forecastTempFour: UILabel!
    @IBOutlet private weak var forecastTempFive: UILabel!
    @IBOutlet private weak var cityButtonTitle: UIButton!
    @IBOutlet private weak var connectionStatus: UILabel!
    
    private lazy var viewModel = WeatherForecastViewModel(delegate: self,
                                                          repository: WeatherForecastRepository(),
                                                          coreDataRepo: FavouriteWeatherForecastsRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDaysOfTheWeek()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getTheWeather()
    }
    
    @IBAction private func changeThemeButtonPressed(_ sender: UIButton) {
        viewModel.flipTheme()
    }
    @IBAction private func favouritesButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToFavourites", sender: self)
    }
    
    @IBAction private func favouriteButtonPressed(_ sender: UIButton) {
        viewModel.attemptSaveLocation()
    }
    
    func setSegued(_ segued: Bool) {
        viewModel.seguedTo = segued
    }
    
    func setSegueCoords(coordinates: Coord) {
        viewModel.coordinatesT = coordinates
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavouriteWeatherForecastsViewController {
            destination.setCity(newCities: viewModel.favouriteLocations)
        }
    }
    
}

extension WeatherForecastViewController: WeatherForecastViewModelDelegate {
    func showError(title: String, error: String) {
        self.showAlert(title: title,
                       message: error,
                       button: "Dismiss")
    }
    
    func displayCurrent(_ formattedData: FormattedCurrent) {
        currentTempBig.text = formattedData.currentTemp
        currentTemp.text = formattedData.currentTemp
        currentMinTemp.text = formattedData.minTemp
        currentMaxTemp.text = formattedData.maxTemp
        cityButtonTitle.setTitle(formattedData.city, for: .normal)
        currentCondition.text = formattedData.condition.rawValue.capitalized
        
        switch viewModel.isOnline {
        case .online:
            connectionStatus.text = "Online"
        case .offline:
            connectionStatus.text = "Last Online: \(formattedData.today.formatDate)"
        }
    }
    
    func displayForecast(_ formattedData: FormattedForecast) {
        forecastTempOne.text = formattedData.weather[0].temp
        forevastTempTwo.text = formattedData.weather[1].temp
        forecastTempThree.text = formattedData.weather[2].temp
        forecastTempFour.text = formattedData.weather[3].temp
        forecastTempFive.text = formattedData.weather[4].temp
        forecastConditionOne.image = UIImage(named: formattedData.weather[0].condition.rawValue)
        forecastConditionTwo.image = UIImage(named: formattedData.weather[1].condition.rawValue)
        forecastConditionThree.image = UIImage(named: formattedData.weather[2].condition.rawValue)
        forcastConditionFour.image = UIImage(named: formattedData.weather[3].condition.rawValue)
        forecastConditionFive.image = UIImage(named: formattedData.weather[4].condition.rawValue)
    }
    
    func displayDays(_ days: [String]) {
        forecastDayOne.text = days[0]
        forecastDayTwo.text = days[1]
        forecastDayThree.text = days[2]
        forecastDayFour.text = days[3]
        forecastDayFive.text = days[4]
    }
    
    func reloadBackground(colour: String, image: String) {
        self.view.backgroundColor = UIColor(named: colour)
        currentConditionBackground.image = UIImage(named: image)
    }
}
