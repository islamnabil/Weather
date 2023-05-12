//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation
import Combine

protocol ForecastViewModelProtocol: AnyObject {
    var state: PassthroughSubject<ForecastViewModel.ForecastPageState, Never> { get }
    var forecast: CurrentValueSubject<ForecastResponse?, Never> { get }
    func fetchForecast(lat: Double, lon: Double)
}


class ForecastViewModel: ForecastViewModelProtocol {
    enum ForecastPageState: Equatable {
        case loading
        case showAPIError(message: String)
        case successed
    }
    
    
    // MARK: - Init
    init(provider: WeatherAPI) {
        self.provider = provider
    }
    
    
    var state = PassthroughSubject<ForecastViewModel.ForecastPageState, Never>()
    var forecast = CurrentValueSubject<ForecastResponse?, Never>(nil)
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
    func fetchForecast(lat: Double, lon: Double) {
        provider?.forecast(lat: lat, lon: lon)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: requestCompletionHandler) { [weak self] in
                if let data = $0 {
                    self?.forecast.value = data
                    self?.state.send(.successed)
                }
            }
            .store(in: &bindings)
    }
    
}
