//
//  DailyDataM.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import Foundation

/// Base data to show
struct DailyDataM {

    // MARK: - Data part

    var data: [DayDataM] = []

    // MARK: - Data particles

    var calendarData: [Date] {
        data.map(\.date)
    }

    func dayTemperatures(date: Date) -> DayDataM? {
        data.first { item in
            item.date == date
        }
    }
}
