//
//  CurrentWeatherVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import UIKit
import Combine

class CurrentWeatherVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    // Weather IBOutlets
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibiltyLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    // MARK: - Properties
    enum TempUnit: String {
        case Celsius = "C"
        case Fahrenheit = "F"
    }
    private var viewModel: CurrentWeatherViewModelProtocol?
    private var bindings = Set<AnyCancellable>()
    private var location: LastKnownLocation?
    private var currentWeather: Weather? {
        didSet {
            updateViewsData()
        }
    }
    private var timer = Timer()
    private var currentUnit: TempUnit = .Fahrenheit
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forecast"
        searchBar.delegate = self
        setupBindings()
        if let location {
            viewModel?.fetchCurrentWeather(lat: location.lat, lon: location.long)
        }
    }

    //MARK: - Init
    class func create(location: LastKnownLocation, viewModel: CurrentWeatherViewModelProtocol) -> CurrentWeatherVC {
        let vc = StoryboardScene.Main.currentWeatherVC.instantiate()
        vc.location = location
        vc.viewModel = viewModel
        return vc
    }
    
    //MARK: - IBActions
    @IBAction func currentLocation(_ sender: Any) {
        if let location {
            viewModel?.fetchCurrentWeather(lat: location.lat, lon: location.long)
        }
    }
    
    @IBAction func setLocation(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Location", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Lat"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Lon"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let latTextField = alertController.textFields![0] as UITextField
            let lonTextField = alertController.textFields![1] as UITextField
            
            if let lat = Double(latTextField.text ?? ""), let lon = Double(lonTextField.text ?? "") {
                self.viewModel?.fetchCurrentWeather(lat: lat, lon: lon)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func fahrenheit(_ sender: Any) {
        currentUnit = .Fahrenheit
    }
    
    
    @IBAction func celsius(_ sender: Any) {
        currentUnit  = .Celsius
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
        tempLabel.text = "\(currentWeather?.main.temperature ?? 0.0) \(currentUnit.rawValue)"
        conditionLabel.text = currentWeather?.weather.first?.main ?? ""
        detailsLabel.text = currentWeather?.weather.first?.description ?? ""
        feelsLikeLabel.text = "\(currentWeather?.main.feelsLike ?? 0.0) \(currentUnit.rawValue)"
        minLabel.text = "\(currentWeather?.main.minimumTemperature ?? 0.0) \(currentUnit.rawValue)"
        maxLabel.text = "\(currentWeather?.main.maximumTemperature ?? 0.0) \(currentUnit.rawValue)"
        pressureLabel.text = "\(currentWeather?.main.pressure ?? 0) hPa"
        humidityLabel.text = "\(currentWeather?.main.humidity ?? 0)%"
        visibiltyLabel.text = "\(currentWeather?.visibility ?? 0) m"
        windSpeedLabel.text = "\(currentWeather?.wind.speed ?? 0.0)"
    }
}

// MARK: - UISearchBarDelegate
extension CurrentWeatherVC: UISearchBarDelegate {
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
