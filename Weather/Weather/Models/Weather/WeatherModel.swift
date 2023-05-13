//
//  WeatherModel.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import Foundation

struct Weather: Codable {
    
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dateTime: Int
    let system: System
    let timezone: Int
    let id: Int
    let name: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case dateTime = "dt"
        case system = "sys"
        case timezone
        case id
        case name
        case code = "cod"
    }
    
    struct Coordinate: Codable {
        let longitude: Double
        let latitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temperature: Double
        let feelsLike: Double
        let minimumTemperature: Double
        let maximumTemperature: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let groundLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case minimumTemperature = "temp_min"
            case maximumTemperature = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let direction: Int
        let gust: Double?
        
        enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
            case gust
        }
    }
    
    struct Rain: Codable {
        let oneHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct System: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }

}
