//
//  String+DateTime.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import Foundation

extension String {
    func dateToString (dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                             outputFormat: String = "EEEE HH:mm") -> String? {
        var output: String?
        if let date = toDate(dateFormat: dateFormat) {
            let formatter = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat = outputFormat
            }
           
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            output = formatter.string(from: date)
        }
        
        return output
    }
    
    
    
    func toDate(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
}
