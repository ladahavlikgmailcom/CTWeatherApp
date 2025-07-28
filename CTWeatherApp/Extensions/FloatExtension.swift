//
//  FloatExtension.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import SwiftUI

extension Float {
    /// Return formated value to Temperature Celsius
    func toCelsiusDegrees() -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short

        return formatter.string(from: Measurement(value: Double(self), unit: UnitTemperature.celsius))
    }
}
