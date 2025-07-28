//
//  ForecastScreenVM.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI

extension ForecastScreenV {
    @Observable
    class ForecastScreenVM {

        // MARK: - Local variables

        var weatherDataProvider: WeatherDataProvider = WeatherDataProvider()
        var locationManager: LocationManager?

        // MARK: - Initializer

        init() {
            locationManager = LocationManager(selectedLocation: Binding(
                get: { self.weatherDataProvider.selectedLocation },
                set: { self.weatherDataProvider.selectedLocation = $0 }
            ))

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

        var showAlert: Binding<Bool> {
            Binding(
                get: { self.weatherDataProvider.showAlert },
                set: { self.weatherDataProvider.showAlert = $0 }
            )
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
