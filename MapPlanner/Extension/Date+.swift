//
//  Date+.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    func toString(_ dateFormat: String) -> String {
        Date.dateFormatter.dateFormat = dateFormat
        return Date.dateFormatter.string(from: self)
    }
    
    func isEqual(_ target: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: target)
    }
}
