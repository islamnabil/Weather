//
//  HomeVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - Properties
    private var lastKnownLocation: LastKnownLocation?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.setupLocation()
        LocationManager.shared.delegate = self
    }
    

    @IBAction func forecast(_ sender: Any) {
        if let lastKnownLocation {
            let vc = ForecastVC.create(location: lastKnownLocation, viewModel: ForecastViewModel(provider: WeatherAPI()))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - LocationManagerProtocol
extension HomeVC: LocationManagerProtocol {
    func locationFetched(location: LastKnownLocation) {
        lastKnownLocation  = location
    }
    
}
