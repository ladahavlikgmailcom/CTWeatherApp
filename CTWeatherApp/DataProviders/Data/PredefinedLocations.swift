//
//  PredefinedLocations.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import Foundation
import CoreLocation

/// Predefined Location for Button selection
enum PredefinedLocations: CaseIterable {
    case prague
    case london
    case newYork

    /// Return istance of Location
    var instance: LocationM {
        switch self {
        case .prague:
            return LocationM(
                label: String(localized: .sPrague),
                coordinates:
                    CLLocationCoordinate2D(
                        latitude: 50.0878,
                        longitude: 14.4207
                    )
            )

        case .london:
            return LocationM(
                label: String(localized: .sLondon),
                coordinates:
                    CLLocationCoordinate2D(
                        latitude: 51.5074,
                        longitude: -0.1278
                    )
            )

        case .newYork:
            return LocationM(
                label: String(localized: .sNewYork),
                coordinates:
                    CLLocationCoordinate2D(
                        latitude: 40.7128,
                        longitude: -74.0060
                    )
            )
        }
    }
}
