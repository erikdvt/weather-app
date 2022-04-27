//
//  FavouriteWeatherForecastsViewController.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation
import UIKit

class FavouriteWeatherForecastsViewController: UIViewController {
    @IBOutlet weak var citiesTableView: UITableView!
    
    private lazy var viewModel = FavouriteWeatherForecastsViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.displayCities()
    }
    
    func setupTableView() {
        self.citiesTableView.delegate = self
        self.citiesTableView.dataSource = self
    }
    
    
}

// MARK: - TableView Delagate

extension FavouriteWeatherForecastsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cityDataCell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? LocationTableViewCell else { return UITableViewCell()}
        //guard let city = viewModel.cities[indexPath.row] else { return UITableViewCell() }
        let city = viewModel.cities[indexPath.row]
        cityDataCell.populateWith(cityName: city)
        cityDataCell.setNeedsLayout()
        
        return cityDataCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToForecast", sender: self)

    }
}

// MARK: - ViewModel Delagate

extension FavouriteWeatherForecastsViewController: FavouriteWeatherForecastsViewModelDelegate {
    func reloadView() {
        citiesTableView.reloadData()
    }
}
