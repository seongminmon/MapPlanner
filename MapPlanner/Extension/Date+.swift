//
//  Date+.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import Foundation

enum DateFormat {
    static let untilMonth = "yyyy.MM"
    static let untilDay = "yyyy.MM.dd"
    static let untilWeekDay = "yyyy.MM.dd (E)"
    static let untilTime = "yyyy.MM.dd (E) a hh:mm"
    static let time = "a hh:mm"
}

extension Date {
    static let dateFormatter = DateFormatter()
    static let startDate = Calendar.current.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    static let endDate = Calendar.current.date(from: DateComponents(year: 2050, month: 12, day: 31))!
    
    func toString(_ dateFormat: String) -> String {
        Self.dateFormatter.dateFormat = dateFormat
        return Self.dateFormatter.string(from: self)
    }
    
    /// 변경하려는 월 반환
    func byAddingMonth(_ value: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: value, to: self)
    }
    
    /// 달의 첫 날짜 얻기
    func firstDayOfMonth() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)
    }
    
    /// 00:00:00시 얻기
    func startOfDay() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDaysInMonth() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    
    /// 연/월/일까지 비교
    func compareUntilDay(_ target: Date?) -> Bool {
        guard let target else { return false }
        return Calendar.current.isDate(self, inSameDayAs: target)
    }
    
    /// 연/월까지 비교
    func compareUntilMonth(_ target: Date?) -> Bool {
        guard let target else { return false }
        let year1 = Calendar.current.component(.year, from: self)
        let month1 = Calendar.current.component(.month, from: self)
        let year2 = Calendar.current.component(.year, from: target)
        let month2 = Calendar.current.component(.month, from: target)
        return year1 == year2 && month1 == month2
    }
}
