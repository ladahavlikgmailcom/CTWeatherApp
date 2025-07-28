//
//  DateExtension.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import Foundation

extension Date {

    /// Return day name for Date
    func takeDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEEE"
        return dateFormatter.string(from: self)
    }

    /// Return day number for Date
    func takeDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}
