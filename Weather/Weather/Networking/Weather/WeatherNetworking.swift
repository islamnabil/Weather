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
}

private enum WeatherEndpoints: String {
    case forecast = "/data/2.5/forecast"
    
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forecast:
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
        }
    }
    
    var headers: [String : String]? {
        return  nil
    }

}
