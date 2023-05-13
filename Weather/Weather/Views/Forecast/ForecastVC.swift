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
    @IBOutlet weak var forecastTableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: ForecastViewModelProtocol?
    private var bindings = Set<AnyCancellable>()
    private var location: LastKnownLocation?
    private var forecastList: [Forecast] = [] {
        didSet {
            forecastTableView.reloadData()
        }
    }
    private var timer = Timer()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupForecastTable()
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
    private func  setupForecastTable() {
        forecastTableView.register(UINib(nibName: "\(ForecastTableCell.self)", bundle: nil), forCellReuseIdentifier: "\(ForecastTableCell.self)")
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel?.forecast
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                if let forecastList = $0?.list {
                    self?.forecastList = forecastList
                }
            }
            .store(in: &bindings)
    }

}

// MARK: - UISearchBarDelegate
extension ForecastVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.output), userInfo: searchText, repeats: false)
    }
    
    @objc func output(){
        if let query = searchBar.text, !query.isEmpty {
            viewModel?.geocodeByName(cityName: query)
        }
        timer.invalidate()
    }

}


// MARK: - UITableViewDelegate
extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ForecastTableCell.self)", for: indexPath) as? ForecastTableCell else { return UITableViewCell() }
        let forecast = forecastList[indexPath.row]
        cell.config(time: forecast.dtTxt ?? "", weatherCondition: forecast.weather?.first?.main ?? "", temp: forecast.main?.temp ?? 0.0)
        cell.selectionStyle = .none
        return cell
    }
    
}
