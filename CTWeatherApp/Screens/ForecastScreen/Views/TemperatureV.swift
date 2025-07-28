//
//  TemperatureView.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import SwiftUI

struct TemperatureV: View {

    // MARK: - Local variables

    // Day data to render
    let dayTemperatures: DayDataM?

    // MARK: - Body part

    var body: some View {
        HStack {
            values(type: .minTemp)
            values(type: .maxTemp)
        }
        .padding(16)
    }

    // MARK: - Body particles

    // Render min or max temperature
    func values(type: TemperatureVType) -> some View {
        VStack {
            Text(type.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(
                type == .minTemp
                ? dayTemperatures?.temperature2mMin.toCelsiusDegrees() ?? String(localized: .sNA)
                : dayTemperatures?.temperature2mMax.toCelsiusDegrees() ?? String(localized: .sNA)
            )
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.accent)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
