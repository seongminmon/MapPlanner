//
//  Date+.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import Foundation

extension Date {
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDayDate: String {
        return Date.calendarDayDateFormatter.string(from: self)
    }
}
