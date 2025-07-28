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
    @Bindable var vm: ForecastScreenVM = ForecastScreenVM()

    // MARK: - Body particles

    var body: some View {
        VStack {
            // Calendar to select date
            HorizontalCalendarV(
                calendarData: vm.calendarData,
                selectedDate: $vm.weatherDataProvider.selectedDate
            )
            .frame(maxHeight: 65)

            // Show max and min temperature for selected day
            TemperatureV(dayTemperatures: vm.dayTemperatures)

            Divider().padding(.bottom)

            // Buttons for predefined locations
            ButtonGridV { location in
                vm.setNewLocation(location)
            }
        }
        .padding(.horizontal)
        .alert(isPresented: vm.showAlert) {
            // Show message when Error happened
            Alert(
                title: Text(String(localized: .sImportantMessage)).foregroundStyle(.accent),
                message: Text(vm.weatherDataProvider.errorInfo ?? String(localized: .sErrorDefault)),
                dismissButton: .default(Text(String(localized: .sGotIt)))
            )
        }
    }
}
