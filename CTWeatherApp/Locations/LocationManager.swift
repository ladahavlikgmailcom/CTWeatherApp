//
//  LocationManager.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import Foundation
import CoreLocation

/// When you need Current Location ask for it.
@MainActor
final class LocationManager: NSObject, CLLocationManagerDelegate {

    // MARK: - Local variables

    /// Location Manager
    private let manager = CLLocationManager()
    /// Called with founded location
    private let onLocation: @MainActor (LocationM) -> Void
    /// Called when location did not work
    private let onError: @MainActor () -> Void

    // MARK: - Initializer

    init(
        onLocation: @escaping @MainActor (LocationM) -> Void,
        onError: @escaping @MainActor () -> Void
    ) {
        self.onLocation = onLocation
        self.onError = onError

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
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let coordinates = locations.first?.coordinate else { return }

        Task { @MainActor [weak self] in
            self?.onLocation(.init(label: String(localized: .sCurrentPosition), coordinates: coordinates))
        }
    }

    /// When location did not work well
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        Task { @MainActor [weak self] in
            self?.onError()
        }
    }
}
