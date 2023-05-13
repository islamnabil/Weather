//
//  Location.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import Foundation

struct Location: Codable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
}
