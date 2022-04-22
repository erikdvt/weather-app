//
//  ViewController.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/21.
//

import Foundation
import UIKit

class WeatherForecastViewController: UIViewController {
    
    private lazy var viewModel = WeatherForecastViewModel(delegate: self,
                                                          repository: WeatherForecastRepository())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchWeather()
        viewModel.fetchForecast()
    }

}

extension WeatherForecastViewController: WeatherForecastViewModelDelegate {
    func showError(_ error: String) {
        print(error)
    }
}
