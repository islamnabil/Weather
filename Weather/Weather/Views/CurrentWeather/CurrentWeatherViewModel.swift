//
//  CurrentWeatherViewModel.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import Foundation
import Combine

protocol CurrentWeatherViewModelProtocol: AnyObject {
    var state: PassthroughSubject<CurrentWeatherViewModel.CurrentWeatherPageState, Never> { get }
    var weather: CurrentValueSubject<Weather?, Never> { get }
    func fetchCurrentWeather(lat: Double, lon: Double, unit: APITemp)
    func geocodeByName(cityName: String)
    func geocodeByZip(zip: String)
}

class CurrentWeatherViewModel: CurrentWeatherViewModelProtocol {
    
    enum CurrentWeatherPageState: Equatable {
        case loading
        case showAPIError(message: String)
        case successed
    }
    
    
    // MARK: - Init
    init(provider: WeatherAPI) {
        self.provider = provider
    }
    
    var state = PassthroughSubject<CurrentWeatherViewModel.CurrentWeatherPageState, Never>()
    var weather = CurrentValueSubject<Weather?, Never>(nil)
    private var selectedUnit: APITemp = .Fahrenheit
    private var bindings = Set<AnyCancellable>()
    private var provider: WeatherAPI?
    lazy private var requestCompletionHandler: (Subscribers.Completion<ErrorResponse>) -> Void = { completion in
        switch completion {
        case .failure(let error):
            print(error.msg ?? "")
            self.state.send(.showAPIError(message: error.msg ?? ""))
        case .finished:
            print("Finished")
        }
    }
    
    // MARK: - Public Methods
    func fetchCurrentWeather(lat: Double, lon: Double, unit: APITemp) {
        selectedUnit = unit
        provider?.currentWeather(lat: lat, lon: lon, unit: selectedUnit)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: requestCompletionHandler) { [weak self] in
                if let data = $0 {
                    self?.weather.value = data
                    self?.state.send(.successed)
                }
            }
            .store(in: &bindings)
    }
    
    
    func geocodeByName(cityName: String) {
        provider?.nameGeocoding(cityName: cityName)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: requestCompletionHandler) { [weak self] in
                if let data = $0?.first, let lat = data.lat, let lon = data.lon
                {
                    self?.fetchCurrentWeather(lat: lat , lon: lon, unit: self?.selectedUnit ?? .Fahrenheit)
                } else {
                    self?.geocodeByZip(zip: cityName)
                }
            }
            .store(in: &bindings)
    }
    
    
    func geocodeByZip(zip: String) {
        provider?.zipGeocoding(zip: zip)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: requestCompletionHandler) { [weak self] in
                if let data = $0, let lat = data.lat, let lon = data.lon
                {
                    self?.fetchCurrentWeather(lat: lat , lon: lon, unit: self?.selectedUnit ?? .Fahrenheit)
                }
            }
            .store(in: &bindings)
    }
    
}
