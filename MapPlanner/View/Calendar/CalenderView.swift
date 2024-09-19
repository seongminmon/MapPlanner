//
//  CalenderView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct CalenderView: View {
    
    // TODO: - 일정 있는 날짜는 숫자 대신 다르게 표시하기
    // TODO: - 일정 없는 날짜는 일정 추가하기
    // TODO: - 일정 CRUD
    
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    private let startDate = Calendar.current.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    private let endDate = Calendar.current.date(from: DateComponents(year: 2050, month: 12, day: 31))!
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View {
        headerView
        calendarGridView
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            HStack {
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image.leftTriangle
                            .foregroundColor(canMoveToPreviousMonth() ? Color(.appPrimary) : Color(.appSecondary))
                    }
                    .disabled(!canMoveToPreviousMonth())
                    
                    Text(month, formatter: Self.calendarHeaderDateFormatter)
                        .font(.title2)
                        .bold()
                    
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image.rightTriangle
                            .foregroundColor(canMoveToNextMonth() ? Color(.appPrimary) : Color(.appSecondary))
                    }
                    .disabled(!canMoveToNextMonth())
                }
                Spacer()
                Button {
                    print("리스트 탭")
                } label: {
                    Image.list
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            
            // 요일
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .foregroundColor(Color(.appSecondary))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDaysInMonth(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDaysInMonth(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        let columns = [GridItem](repeating: GridItem(), count: 7)
        
        return LazyVGrid(columns: columns) {
            ForEach(-firstWeekday..<daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        CellView(day: day, clicked: clicked, isToday: isToday)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(day: day, isCurrentMonthDay: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        clickedCurrentMonthDates = date
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var textColor: Color {
        if clicked {
            return Color.white
        } else if isCurrentMonthDay {
            return Color.black
        } else {
            return Color.gray
        }
    }
    private var backgroundColor: Color {
        if clicked {
            return Color.black
        } else if isToday {
            return Color.gray
        } else {
            return Color.white
        }
    }
    
    fileprivate init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    fileprivate var body: some View {
        VStack {
            Circle()
                .fill(backgroundColor)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
            
            Spacer()
            
            if clicked {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .frame(width: 10, height: 10)
            } else {
                Spacer()
                    .frame(height: 10)
            }
        }
        .frame(height: 50)
    }
}

private extension CalenderView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
}

private extension CalenderView {
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: month),
            month: calendar.component(.month, from: month),
            day: 1
        )) else { return Date() }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDaysInMonth(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        self.month = adjustedMonth(by: value)
    }
    
    /// 이전 월로 이동 가능한지 확인
    func canMoveToPreviousMonth() -> Bool {
        return adjustedMonth(by: -1) >= startDate
    }
    
    /// 다음 월로 이동 가능한지 확인
    func canMoveToNextMonth() -> Bool {
        return adjustedMonth(by: 1) <= endDate
    }
    
    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            return newMonth
        }
        return month
    }
}

#Preview {
    CalenderView()
}
