//
//  ButtonGridV.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI

/// Build view with Predefined Location Buttons and One for Current location
struct ButtonGridV: View {

    // MARK: - Local variables

    /// Action to store selected location
    var action: (LocationM?) -> Void

    // MARK: - Body part

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 120, maximum: 200))],
            spacing: 16
        ) {
            // Predefined Buttons
            ForEach(PredefinedLocations.allCases, id: \.self) { item in
                Button(action: { action(item.instance) }) {
                    Text(item.instance.label)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                }
                .buttonStyle(.borderedProminent)
            }
            // Current Location Button
            Button(action: { action(nil) }) {
                Image(systemName: "location.fill")
                    .foregroundStyle(.white)
                    .frame(maxWidth: 44, maxHeight: 44)
                    .background(Circle().fill(.accent))
            }
        }
    }
}
