//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Islam Elgaafary on 12/05/2023.
//

import Foundation
import Alamofire

enum APITemp: String {
    case Celsius = "metric"
    case Fahrenheit = "imperial"
}

enum WeatherNetworking {
    case forecast(lat: Double, lon: Double)
    case geocodingByName(cityName: String)
    case geocofingByZipCode(zip: String)
    case currentWeather(lat: Double, lon: Double, unit: APITemp)
}

private enum WeatherEndpoints: String {
    case forecast = "forecast"
    case geoName = "direct"
    case geoZip = "zip"
    case currentWeather = "weather"
    
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
            return Server.baseDataURL + WeatherEndpoints.forecast.description
        case .geocodingByName:
            return Server.baseGeoURL + WeatherEndpoints.geoName.description
        case .geocofingByZipCode:
            return Server.baseGeoURL + WeatherEndpoints.geoZip.description
        case .currentWeather:
            return Server.baseDataURL + WeatherEndpoints.currentWeather.description
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forecast, .geocodingByName, .geocofingByZipCode, .currentWeather:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .forecast(lat, lon):
            let params = [
                "lat": lat,
                "lon": lon,
                "appid": App.WEATHER_KEY,
                "units": "imperial"
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
            
        case let .currentWeather(lat, lon, temp):
            let params = [
                "lat": lat,
                "lon": lon,
                "appid": App.WEATHER_KEY,
                "units": temp.rawValue
            ] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return  nil
    }

}
