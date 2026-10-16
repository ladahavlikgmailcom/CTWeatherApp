//
//  HorizontalCalendar.swift
//  CTWeatherApp
//
//  Created by David Pařízek on 22.07.2025.
//

import SwiftUI

/// Build Calendar view for Dates in API data
struct HorizontalCalendarV: View {

    // MARK: - Local variables

    /// Set of Dates to show
    let calendarData: [Date]
    /// Store selected date
    @Binding var selectedDate: Date?
    /// Constant to build one Date item
    let itemSize: CGFloat = 56

    // MARK: - Initializer

    init(calendarData: [Date], selectedDate: Binding<Date?>) {
        self.calendarData = calendarData
        self._selectedDate = selectedDate
    }

    // MARK: - Body part

    var body: some View {
        GeometryReader {
            // Actual area to render
            let size = $0.size
            // Padding to center selector
            let horizontalPadding = (size.width / 2) - (itemSize / 2)
            // Horizontal area for Days
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(calendarData, id: \.self) { date in
                        itemDate(date)
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: size.height)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selectedDate, anchor: .center)
            .overlay(alignment: .center) {
                // Selector area
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.accent, lineWidth: 2)
                    .frame(width: itemSize, height: itemSize)
            }
            .safeAreaPadding(.horizontal, horizontalPadding)
        }
    }

    // MARK: - Body particles

    /// Rendered one Date
    @ViewBuilder
    private func itemDate(_ date: Date) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(date.takeDayName())
                .font(.caption)
                .foregroundStyle(foregroundColor(selectedDate == date))
            Text(date.takeDayNumber())
                .font(.headline)
                .foregroundStyle(foregroundColor(selectedDate == date))
        }
        .frame(width: itemSize, height: itemSize)
    }

    /// Set text color
    private func foregroundColor(_ isSelected: Bool) -> Color {
        isSelected ? .accent : .secondary
    }
}
