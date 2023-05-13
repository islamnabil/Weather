//
//  WeatherAPI.swift
//  Weather
//
//  Created by Islam Elgaafary on 12/05/2023.
//

import Foundation
import Alamofire
import Combine

protocol WeatherAPIProtocol {
    func forecast(lat: Double, lon: Double) -> AnyPublisher<ForecastResponse?, ErrorResponse>
    func nameGeocoding(cityName: String) -> AnyPublisher<[Location]?, ErrorResponse>
    func zipGeocoding(zip: String) -> AnyPublisher<Location?, ErrorResponse>
}


class WeatherAPI:  BaseAPI<WeatherNetworking>, WeatherAPIProtocol {
    func forecast(lat: Double, lon: Double) -> AnyPublisher<ForecastResponse?, ErrorResponse> {
        fetchData(target: .forecast(lat: lat, lon: lon))
    }
    
    func nameGeocoding(cityName: String) -> AnyPublisher<[Location]?, ErrorResponse> {
        fetchData(target: .geocodingByName(cityName: cityName))
    }
    
    func zipGeocoding(zip: String) -> AnyPublisher<Location?, ErrorResponse> {
        fetchData(target: .geocofingByZipCode(zip: zip))
    }
}
