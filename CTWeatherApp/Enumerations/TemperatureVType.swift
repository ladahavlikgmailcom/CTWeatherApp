//
//  TemperatureVType.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI

enum TemperatureVType {
    case minTemp
    case maxTemp

    /// return localized string for type
    var title: String {
        switch self {
        case .minTemp:
            return String(localized: .sLabelMin)

        case .maxTemp:
            return String(localized: .sLabelMax)
        }
    }
}
