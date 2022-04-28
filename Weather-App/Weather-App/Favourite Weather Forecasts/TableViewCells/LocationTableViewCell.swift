//
//  LocationTableViewCell.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/27.
//

import Foundation
import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet private var cityNameLabel: UILabel!
    
    func populateWith(cityName: String) {
        cityNameLabel.text = cityName
    }
}
