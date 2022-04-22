//
//  WeatherForecastRepository.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/22.
//

import Foundation

typealias FiveDayForecastResult = (Result<FiveDayForecastModel, CustomError>) -> Void
typealias CurrentWeatherResult = (Result<CurrentWeatherModel, CustomError>) -> Void

protocol WeatherForecastRepositoryType: AnyObject {
    func fetchCurrentWeather(completion: @escaping(CurrentWeatherResult))
    func fetchFiveDayForecast(completion: @escaping(FiveDayForecastResult))
}

class WeatherForecastRepository: WeatherForecastRepositoryType {
    
    func fetchCurrentWeather(completion: @escaping(CurrentWeatherResult)) {
        makeRequest(url: buildURL(base: Constants.currentWeatherURL), model: CurrentWeatherModel.self, completion: completion)
    }
    
    func fetchFiveDayForecast(completion: @escaping(FiveDayForecastResult)) {
        makeRequest(url: buildURL(base: Constants.fiveDayForecastURL), model: FiveDayForecastModel.self, completion: completion)
    }
    
    private func buildURL(base: String) -> URL? {
        let queries = "lat=-33.9249&lon=18.4241"
        let urlString = "\(base)&\(queries)"
        
        return (URL(string: urlString))
    }
    
    private func makeRequest<Generic: Codable>(url: URL?,
                                               model: Generic.Type,
                                               completion: @escaping((Result<Generic, CustomError>) -> Void)) {
        
        guard let endpointUrl = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let request = URLRequest(url: endpointUrl)
        callRequest(with: request, model: model, completion: completion)
    }
        
    private func callRequest<Generic: Codable>(with request: URLRequest, model: Generic.Type, completion: @escaping(Result<Generic, CustomError>) -> Void) {
        
        let apiTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let safeData = data else {
                
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(CustomError.invalidData)) }
                } else {
                    DispatchQueue.main.async { completion(.failure(CustomError.internalError)) }
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(model, from: safeData)
                
                DispatchQueue.main.async {completion(.success(result))}
            } catch {
                DispatchQueue.main.async {completion(.failure(CustomError.parsingError))}
            }
        }
        apiTask.resume()
    }
}
