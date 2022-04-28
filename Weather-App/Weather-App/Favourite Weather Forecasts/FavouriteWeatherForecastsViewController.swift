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
    
    private lazy var viewModel = FavouriteWeatherForecastsViewModel(delegate: self,
                                                                    repository: FavouriteWeatherForecastsRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.displayCities()
    }
    
    func setupTableView() {
        self.citiesTableView.delegate = self
        self.citiesTableView.dataSource = self
    }
    
    func setCity(newCities: [FavLocation]?) {
        viewModel.setCities(newCities: newCities)
    }
    
}

// MARK: - TableView Delagate

extension FavouriteWeatherForecastsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cityDataCell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? LocationTableViewCell else { return UITableViewCell()}
        let city = viewModel.cities[indexPath.row].city ?? "Unknown City"
        cityDataCell.populateWith(cityName: city)
        cityDataCell.setNeedsLayout()
        
        return cityDataCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToForecast", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherForecastViewController {
            destination.setSegued(true)
            guard let cityIndex = citiesTableView.indexPathForSelectedRow?.row else {return}
            let segCoord = Coord(lon: viewModel.cities[cityIndex].lon, lat: viewModel.cities[cityIndex].lat)
            destination.setSegueCoords(coordinates: segCoord)
        }
    }

}

// MARK: - ViewModel Delagate

extension FavouriteWeatherForecastsViewController: FavouriteWeatherForecastsViewModelDelegate {
    func reloadView() {
        citiesTableView.reloadData()
    }
}
