//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Islam Elgaafary on 14/05/2023.
//

import Foundation

import Foundation

class UserDefaultsManager {
    
    //MARK: Singleton
    static let shared = UserDefaultsManager()
    
    private struct UserDefaultsKeys {
        static let forecastSearches = "UDForecatSearches"
    }
    
    //MARK: Properties
    var forecastSearches:[String] {
        return UserDefaults.standard.object(forKey: UserDefaultsKeys.forecastSearches) as? [String] ?? []
    }
    
    func addNewForecastSearch(forecast: String) {
        var forecastSearches = self.forecastSearches
        
        if forecastSearches.count == 5 {
            forecastSearches.removeFirst()
        }
        
        forecastSearches.append(forecast)
        
        UserDefaults.standard.set(forecastSearches , forKey: UserDefaultsKeys.forecastSearches)
    }
}
