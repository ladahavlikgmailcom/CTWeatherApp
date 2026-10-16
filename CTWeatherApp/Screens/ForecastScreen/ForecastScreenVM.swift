//
//  ForecastScreenVM.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI

extension ForecastScreenV {
    @MainActor
    @Observable
    final class ForecastScreenVM {

        // MARK: - Local variables

        let weatherDataProvider = WeatherDataProvider()
        private(set) var locationManager: LocationManager?

        // MARK: - Initializer

        init() {
            let provider = weatherDataProvider
            // weak capture: no retain cycle between provider and location manager
            locationManager = LocationManager(
                onLocation: { [weak provider] location in
                    provider?.selectedLocation = location
                },
                onError: { [weak provider] in
                    provider?.handleError(.location)
                }
            )

            loadData()
        }

        // MARK: - Data

        private func loadData() {
            weatherDataProvider.loadWeatherData()
        }

        // MARK: - Intents

        var calendarData: [Date] {
            weatherDataProvider.calendarData
        }

        var dayTemperatures: DayDataM? {
            weatherDataProvider.dayTemperatures
        }

        var showDayTemperatures: Bool {
            dayTemperatures != nil
        }

        var selectedDate: Date? {
            get { weatherDataProvider.selectedDate }
            set { weatherDataProvider.selectedDate = newValue }
        }

        var showAlert: Bool {
            get { weatherDataProvider.showAlert }
            set { weatherDataProvider.showAlert = newValue }
        }

        func setNewLocation(_ newLocation: LocationM?) {
            if let newLocation {
                weatherDataProvider.selectedLocation = newLocation
            } else {
                locationManager?.requestLocation()
            }
        }
    }
}
