//
//  HomeVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import UIKit
import Combine

class HomeVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    // MARK: - Properties
    private var lastKnownLocation: LastKnownLocation?
    private var viewModel: CurrentWeatherViewModelProtocol?
    private var bindings = Set<AnyCancellable>()
    private var currentWeather: Weather? {
        didSet {
            updateViewsData()
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.setupLocation()
        LocationManager.shared.delegate = self
        viewModel = CurrentWeatherViewModel(provider: WeatherAPI())
        setupBindings()
    }
    
    // MARK: - IBActions
    @IBAction func forecast(_ sender: Any) {
        if let lastKnownLocation {
            let vc = ForecastVC.create(location: lastKnownLocation, viewModel: ForecastViewModel(provider: WeatherAPI()))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func currentWeather(_ sender: Any) {
        if let lastKnownLocation {
            let vc = CurrentWeatherVC.create(location: lastKnownLocation, viewModel: CurrentWeatherViewModel(provider: WeatherAPI()))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        viewModel?.weather
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                if let weather = $0 {
                    self?.currentWeather = weather
                }
            }
            .store(in: &bindings)
    }
    
    private func updateViewsData() {
        locationNameLabel.text = currentWeather?.name ?? ""
        tempLabel.text = "\(currentWeather?.main.temperature ?? 0.0)"
    }
}

// MARK: - LocationManagerProtocol
extension HomeVC: LocationManagerProtocol {
    func locationFetched(location: LastKnownLocation) {
        lastKnownLocation  = location
        viewModel?.fetchCurrentWeather(lat: location.lat, lon: location.long, unit: .Fahrenheit)
    }
    
}
