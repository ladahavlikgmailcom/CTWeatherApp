//
//  WeatherDataProvider.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import SwiftUI
import OpenMeteoSdk

/// Provided weather data for view and read it from API on selcted location
@Observable
final class WeatherDataProvider {

    // MARK: - Local variables

    /// API Data store
    var dailyData: DailyDataM
    /// Selected Date in Calendar
    var selectedDate: Date?
    /// Error notification observer
    var errorNotification: NSObjectProtocol?
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
    var selectedLocation: LocationM {
        didSet {
            // With new location load data
            loadWeatherData()
        }
    }


    // MARK: - Initializer

    init() {
        // when start Prague is default location
        selectedLocation = PredefinedLocations.prague.instance
        dailyData = DailyDataM()

        // Create Error observer
        errorNotification = NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name("Error"),
                object: nil,
                queue: .main,
                using: { [unowned self] notification in
                    self.handleError(notification)
                })
    }

    deinit {
        if let errorNotification {
            // Erase Error observer
            NotificationCenter.default.removeObserver(errorNotification)
        }
    }

    // MARK: - Data

    /// Contact API for weather data for selected location
    internal func loadWeatherData() {
        let restApiClient = RestApiClient()
        Task {
            // Ask for data
            guard let response = await restApiClient.getWeatherData(for: selectedLocation) else { return }
            // Have Daily part?
            guard let daily = response.first?.daily else { return }
            // Read raw data
            let weatherData = WeatherDataM(
                daily: .init(
                    time: daily.getDateTime(),
                    temperature2mMax: daily.variables(at: 0)!.values,
                    temperature2mMin: daily.variables(at: 1)!.values
                )
            )
            // Transformation to View Model
            var newDayData: [DayDataM] = .init()
            for (i, date) in weatherData.daily.time.enumerated() {
                newDayData.append(
                    DayDataM(
                        date: date,
                        temperature2mMax: weatherData.daily.temperature2mMax[i],
                        temperature2mMin: weatherData.daily.temperature2mMin[i]
                    )
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
    func handleError(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo["type"] as? String else { return }

        switch type {
        case "location":
            errorInfo = String(localized: .sErrorLocation)
        case "API":
            errorInfo = String(localized: .sErrorAPI)
        default:
            errorInfo = String(localized: .sErrorDefault)
        }
        showAlert = true
    }
}
