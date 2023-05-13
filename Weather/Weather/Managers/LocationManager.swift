//
//  LocationManager.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation
import CoreLocation

public protocol LocationManagerProtocol {
    func locationFetched(location: LastKnownLocation)
}

public class LocationManager: NSObject {
    
    //MARK: - Singleton
    public static let shared = LocationManager()
    private override init() {
        super.init()
    }
    
    //MARK: - Properties
    public var delegate: LocationManagerProtocol?
    private let locationManager = CLLocationManager()
    private lazy var geocoder = CLGeocoder()
    
    //MARK: - Public Methods
    public func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}


//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.geocoder.reverseGeocodeLocation(CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)) { [weak self] (placemarks, error) in
            guard self != nil else { return }
            if let placemarks = placemarks, let placemark = placemarks.first, error == nil {
              let fetchedLocation = LastKnownLocation(name: placemark.name ?? "My Location", lat: Double(locValue.latitude), long: Double(locValue.longitude))
                self?.delegate?.locationFetched(location: fetchedLocation)
            }
        }

        locationManager.stopUpdatingLocation()
    }
}


public struct LastKnownLocation: Codable {
    internal init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    public var name: String
    public var lat: Double
    public var long: Double
}
