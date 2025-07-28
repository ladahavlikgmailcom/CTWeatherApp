//
//  WeatherDataM.swift
//  CTWeatherApp
//
//  Created by [ laďa ] HAVLÍK on 26.07.2025.
//

import Foundation

/// Struct to process API data in first step
struct WeatherDataM {
    let daily: Daily

    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}
