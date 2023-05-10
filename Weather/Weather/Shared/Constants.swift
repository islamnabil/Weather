//
//  Constants.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation

struct App {
    static let WEATHER_KEY = "7128bf67ef7252cbb73773843f9347e7"

}

struct Server {
    static var baseURL: String {
        "https://api.openweathermap.org/data/2.5/forecast/"
    }
}

struct HTTPCode {
    static let notFound404 = 404
    static let unauthorised401 = 401
    static let unprocessableEntity422 = 422
}

struct ErrorDomain {
    static let http = ""
    static let connection = ""
    static let server = ""
}

struct Message {
    static let noDataReturned = "No Data Returned."
    static let HTTPToken = "HTTP Token: Access denied."
    static let genericError = "Something went wrong"
    static let invalidPassword = "Password must be atleast 8 characters, contain a letter, number, and symbol"
    static let invalidName = "Please enter a valid name"
    static let invalidPhone = "Please enter a valid phone"
    static let passwordMatch = "Passwords must match"
    static let invalidCredentials = "Email or password is incorrect"
    static let takenEmail = "Email already taken"
    static let userCanceledSocialLogin = "User cancelled login"
    static let socialInfoNotComplete = "Please allow access to name and email"
}
