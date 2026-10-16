//
//  WeatherDataProvider.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import SwiftUI
import OpenMeteoSdk

/// Kinds of errors shown to the user
enum WeatherError {
    case location
    case api
    case unknown
}

/// Provided weather data for view and read it from API on selcted location
@MainActor
@Observable
final class WeatherDataProvider {

    // MARK: - Local variables

    /// API Data store
    var dailyData = DailyDataM()
    /// Selected Date in Calendar
    var selectedDate: Date?
    /// Error message for Alert
    var errorInfo: String?
    /// Show Error Alert object
    var showAlert: Bool = false {
        didSet {
            // if alert dismiss, erase error message
            if showAlert == false {
                errorInfo = nil
            }
        }
    }
    /// Currently selected Predefined location or Current location
    @ObservationIgnored
    var selectedLocation: LocationM = PredefinedLocations.prague.instance {
        didSet {
            // With new location load data
            loadWeatherData()
        }
    }

    /// Running request, cancelled when a newer one starts
    @ObservationIgnored
    private var loadTask: Task<Void, Never>?

    // MARK: - Data

    /// Contact API for weather data for selected location
    func loadWeatherData() {
        loadTask?.cancel()
        let location = selectedLocation
        loadTask = Task {
            do {
                // Ask for data
                let response = try await RestApiClient().getWeatherData(for: location)
                guard !Task.isCancelled else { return }
                // Have Daily part?
                guard let daily = response.first?.daily,
                      let maxValues = daily.variables(at: 0)?.values,
                      let minValues = daily.variables(at: 1)?.values else { return }
                // Read raw data
                let weatherData = WeatherDataM(
                    daily: .init(
                        time: daily.getDateTime(),
                        temperature2mMax: maxValues,
                        temperature2mMin: minValues
                    )
                )
                // Transformation to View Model
                let newDayData = weatherData.daily.time.enumerated().map { i, date in
                    DayDataM(
                        date: date,
                        temperature2mMax: weatherData.daily.temperature2mMax[i],
                        temperature2mMin: weatherData.daily.temperature2mMin[i]
                    )
                }

                // Set selected date from new set of data
                if let selectedDate, let dataForSameDay = newDayData.first(where: {
                    Calendar.current.isDate(selectedDate, equalTo: $0.date, toGranularity: .day)
                }) {
                    self.selectedDate = dataForSameDay.date
                } else {
                    // Set first date from data
                    selectedDate = newDayData.first?.date
                }
                // Store data to show
                dailyData.data = newDayData
            } catch is CancellationError {
                return
            } catch {
                handleError(.api)
            }
        }
    }

    // MARK: - View data

    /// List of Dates for Calendar
    var calendarData: [Date] {
        dailyData.calendarData
    }

    /// Day Date for selected date
    var dayTemperatures: DayDataM? {
        guard let selectedDate else { return nil }
        return dailyData.dayTemperatures(date: selectedDate)
    }

    // MARK: - Error handling

    /// Processing Error state from any part of code
    func handleError(_ error: WeatherError) {
        switch error {
        case .location:
            errorInfo = String(localized: .sErrorLocation)
        case .api:
            errorInfo = String(localized: .sErrorAPI)
        case .unknown:
            errorInfo = String(localized: .sErrorDefault)
        }
        showAlert = true
    }
}
