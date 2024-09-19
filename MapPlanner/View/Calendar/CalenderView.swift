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
    
    @State private var showDatePicker = false
    @State private var selectedYear = 0
    @State private var selectedMonth = 0
    
    static let startDate = Calendar.current.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    static let endDate = Calendar.current.date(from: DateComponents(year: 2050, month: 12, day: 31))!
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
    
    func setYearAndMonth() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: month)
        selectedYear = components.year ?? 2024
        selectedMonth = components.month ?? 1
    }
    
    var today: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return Calendar.current.date(from: components)!
    }
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
            Spacer()
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheetView(
                month: $month,
                showDatePicker: $showDatePicker,
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth
            )
        }
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
                    
                    Button {
                        setYearAndMonth()
                        showDatePicker.toggle()
                    } label: {
                        Text(month.toString("yyyy.MM"))
                            .font(.title2)
                            .bold()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
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
                    month = Date()
                } label: {
                    Image.refresh
                        .bold()
                        .foregroundStyle(Color(.appPrimary))
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
                        let isToday = date.toString("MMMM yyyy dd") == today.toString("MMMM yyyy dd")
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
        return adjustedMonth(by: -1) >= Self.startDate
    }
    
    /// 다음 월로 이동 가능한지 확인
    func canMoveToNextMonth() -> Bool {
        return adjustedMonth(by: 1) <= Self.endDate
    }
    
    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
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
            return Color(.background)
        } else if isCurrentMonthDay {
            return Color(.appPrimary)
        } else {
            return Color(.appSecondary)
        }
    }
    private var backgroundColor: Color {
        if clicked {
            return Color(.appPrimary)
        } else if isToday {
            return Color(.appSecondary)
        } else {
            return Color(.background)
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

struct DatePickerSheetView: View {
    
    @Binding var month: Date
    @Binding var showDatePicker: Bool
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    
    private let years = Array(2020...2050)
    private let months = Array(1...12)
    
    var body: some View {
        VStack {
            Spacer()

            HStack {
                // 연도 선택기
                Picker("연도", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)년").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                // 월 선택기
                Picker("월", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text("\(month)월").tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            .padding()

            // 이동 버튼
            Button {
                moveToDatePickerDate()
                showDatePicker = false
            } label: {
                Text("이동")
                    .font(.system(size: 16))
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .foregroundColor(Color(.background))
                    .background(Color(.button))
                    .clipShape(.capsule)
            }
            .padding(.horizontal)
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.45)])
    }
    
    func moveToDatePickerDate() {
        month = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}


#Preview {
    CalenderView()
}
