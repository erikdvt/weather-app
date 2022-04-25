//
//  Double.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/25.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%.0f°", self)
    }
}
