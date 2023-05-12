//
//  ForecastVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import UIKit
import Combine

class ForecastVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
   
    // MARK: - Properties
    private var viewModel: ForecastViewModelProtocol?
    private var bindings = Set<AnyCancellable>()
    private var location: LastKnownLocation?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        if let location {
            viewModel?.fetchForecast(lat: location.lat, lon: location.long)
        }
    }
    
    //MARK: - Init
    class func create(location: LastKnownLocation, viewModel: ForecastViewModelProtocol) -> ForecastVC {
        let vc = StoryboardScene.Main.forecastVC.instantiate()
        vc.location = location
        vc.viewModel = viewModel
        return vc
    }
    
    //MARK: - IBActions
    @IBAction func currentLocation(_ sender: Any) {
        if let location {
            viewModel?.fetchForecast(lat: location.lat, lon: location.long)
        }
    }
    
    
    @IBAction func setLocation(_ sender: Any) {
        
    }
    
    
    // MARK: - Private Methods
    private func setupBindings() {
        viewModel?.forecast
            .receive(on: RunLoop.main)
            .sink { _ in
                let x = self.viewModel?.forecast.value
                
            }
            .store(in: &bindings)
    }

}
