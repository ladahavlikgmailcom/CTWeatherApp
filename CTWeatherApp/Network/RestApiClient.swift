//
//  RestApiClient.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import Foundation
import OpenMeteoSdk

/// Client for contact API
struct RestApiClient {

    // MARK: - Local variables

    /// Where are API points
    private let baseUrlString: String = "https://api.open-meteo.com/v1/forecast"

    // MARK: - Body part

    /// Get forecast data from API for location. Throws when URL cannot be built or the request fails.
    func getWeatherData(for location: LocationM) async throws -> [WeatherApiResponse] {
        // get url for location
        guard let url = createUrlForLocation(for: location) else { throw URLError(.badURL) }
        // take data from API
        return try await WeatherApiResponse.fetch(url: url)
    }

    // MARK: - Body particles

    /// Create URL for selected Location.
    private func createUrlForLocation(for location: LocationM) -> URL? {
        // decode base url
        guard let url = URL(string: baseUrlString) else { return nil }
        // create components
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        // add query items
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinates.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinates.longitude)),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "format", value: "flatbuffers")
        ]
        return components.url
    }
}
