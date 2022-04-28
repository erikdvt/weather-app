//
//  ServiceErrors.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

enum CustomError: String, Error {
    case invalidResponse
    case invalidRequest
    case invalidUrl
    case invalidData
    case internalError
    case parsingError
}
