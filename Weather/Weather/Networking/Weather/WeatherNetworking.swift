//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Islam Elgaafary on 12/05/2023.
//

import Foundation
import Alamofire

enum WeatherNetworking {
    case forecast(lat: Double, lon: Double)
    case geocodingByName(cityName: String)
    case geocofingByZipCode(zip: String)
}

private enum WeatherEndpoints: String {
    case forecast = "/data/2.5/forecast"
    case geoName = "/geo/1.0/direct"
    case geoZip = "/geo/1.0/zip"
    
    var description: String {
        return self.rawValue
    }
    
}


extension WeatherNetworking: TargetType {
    var baseURL: String {
        Server.baseURL
    }
    
    var path: String {
        switch self {
        case .forecast:
            return WeatherEndpoints.forecast.description
        case .geocodingByName:
            return WeatherEndpoints.geoName.description
        case .geocofingByZipCode:
            return WeatherEndpoints.geoZip.description
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forecast, .geocodingByName, .geocofingByZipCode:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .forecast(lat, lon):
            let params = [
                "lat": lat,
                "lon": lon,
                "appid": App.WEATHER_KEY
            ] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .geocodingByName(cityName: let cityName):
            let params = [
                "q": cityName,
                "appid": App.WEATHER_KEY
            ] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .geocofingByZipCode(zip: let zip):
            let params = [
                "zip": zip,
                "appid": App.WEATHER_KEY
            ] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return  nil
    }

}
