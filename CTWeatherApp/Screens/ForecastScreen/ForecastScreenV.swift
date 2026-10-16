//
//  ForecastScreenV.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import SwiftUI
import CoreLocation

/// View for Calendar, Temperatures and Location Buttons
struct ForecastScreenV: View {

    // MARK: - Local variables

    /// view model
    @State private var vm = ForecastScreenVM()

    // MARK: - Body particles

    var body: some View {
        // Scrollable, so content stays reachable in small windows and at large text sizes
        ScrollView {
            VStack {
                // Calendar to select date
                HorizontalCalendarV(
                    calendarData: vm.calendarData,
                    selectedDate: $vm.selectedDate
                )
                // fixed height: GeometryReader inside a ScrollView has no height proposal
                .frame(height: 65)

                // Show max and min temperature for selected day
                TemperatureV(dayTemperatures: vm.dayTemperatures)

                Divider().padding(.bottom)

                // Buttons for predefined locations
                ButtonGridV { location in
                    vm.setNewLocation(location)
                }
            }
            .padding(.horizontal)
        }
        // Show message when Error happened
        .alert(Text(.sImportantMessage), isPresented: $vm.showAlert) {
            Button(.sGotIt) {}
        } message: {
            Text(vm.weatherDataProvider.errorInfo ?? String(localized: .sErrorDefault))
        }
    }
}
