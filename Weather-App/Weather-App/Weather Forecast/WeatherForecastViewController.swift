//
//  ViewController.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/21.
//

import Foundation
import UIKit

class WeatherForecastViewController: UIViewController {
    
    @IBOutlet weak var currentConditionBackground: UIImageView!
    @IBOutlet weak var currentCondition: UILabel!
    @IBOutlet weak var currentTempBig: UILabel!
    @IBOutlet weak var currentMinTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentMaxTemp: UILabel!
    @IBOutlet weak var forecastDayOne: UILabel!
    @IBOutlet weak var forecastDayTwo: UILabel!
    @IBOutlet weak var forecastDayThree: UILabel!
    @IBOutlet weak var forecastDayFour: UILabel!
    @IBOutlet weak var forecastDayFive: UILabel!
    @IBOutlet weak var forecastConditionOne: UIImageView!
    @IBOutlet weak var forecastConditionTwo: UIImageView!
    @IBOutlet weak var forecastConditionThree: UIImageView!
    @IBOutlet weak var forcastConditionFour: UIImageView!
    @IBOutlet weak var forecastConditionFive: UIImageView!
    @IBOutlet weak var forecastTempOne: UILabel!
    @IBOutlet weak var forevastTempTwo: UILabel!
    @IBOutlet weak var forecastTempThree: UILabel!
    @IBOutlet weak var forecastTempFour: UILabel!
    @IBOutlet weak var forecastTempFive: UILabel!
    
    private lazy var viewModel = WeatherForecastViewModel(delegate: self,
                                                          repository: WeatherForecastRepository())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDaysOfTheWeek()
        viewModel.fetchWeather()
        viewModel.fetchForecast()
    }
}

extension WeatherForecastViewController: WeatherForecastViewModelDelegate {
    func showError(_ error: String) {
        print(error)
    }
    
    func displayCurrent(_ formattedData: FormattedCurrent) {
        currentTempBig.text = formattedData.currentTemp
        currentTemp.text = formattedData.currentTemp
        currentMinTemp.text = formattedData.minTemp
        currentMaxTemp.text = formattedData.maxTemp
        currentCondition.text = formattedData.description
    }
    
    func displayForecast(_ formattedData: FormattedForecast) {
        forecastTempOne.text = formattedData.weather[0].temp
        forevastTempTwo.text = formattedData.weather[1].temp
        forecastTempThree.text = formattedData.weather[2].temp
        forecastTempFour.text = formattedData.weather[3].temp
        forecastTempFive.text = formattedData.weather[4].temp
    }
    
    func displayDays(_ days: [String]) {
        forecastDayOne.text = days[0]
        forecastDayTwo.text = days[1]
        forecastDayThree.text = days[2]
        forecastDayFour.text = days[3]
        forecastDayFive.text = days[4]
    }
}
