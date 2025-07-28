//
//  LocationManager.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI
import CoreLocation

/// When you need Current Location ask for it.
final class LocationManager: NSObject, CLLocationManagerDelegate {

    // MARK: - Local variables

    /// Location Manager
    private let manager = CLLocationManager()
    /// Store founded location
    @Binding var selectedLocation: LocationM

    // MARK: - Initializer

    init(selectedLocation: Binding<LocationM>) {
        self._selectedLocation = selectedLocation

        super.init()

        // CLLocationManagerDelegate setting
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    // MARK: - Location stubs

    /// Ask for current location
    func requestLocation() {
        if [.authorizedWhenInUse, .authorizedAlways].contains(manager.authorizationStatus) {
            manager.requestLocation()
        }
    }

    /// Take location from manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else {
            manager.stopUpdatingLocation()
            return
        }

        selectedLocation = .init(label: String(localized: .sCurrentPosition), coordinates: coordinates)

        manager.stopUpdatingLocation()
    }

    /// When location did not work well
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        NotificationCenter.default.post(name: NSNotification.Name("Error"), object: nil, userInfo: ["type" : "location"])
    }
}
