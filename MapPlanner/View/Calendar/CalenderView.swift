//
//  CalenderView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct CalendarView: View {
    
    // 시작 ~ 끝 날짜 (2020-01-01 ~ 2050-12-31)
    static let startDate = Calendar.current.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    static let endDate = Calendar.current.date(from: DateComponents(year: 2050, month: 12, day: 31))!
    // ["일", "월", "화", "수", "목", "금", "토"]
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
    
    // Realm에 저장된 일정 데이터
    @ObservedResults(Plan.self) var plans
    
    // 달력 표시되고 있는 달 (연, 월 까지만 유효)
    @State private var currentDate = Date()
    // 유저가 선택할 날짜 (일까지 유효)
    @State private var clickedDate: Date?
    
    // 데이트 피커 관련
    @State private var showDatePicker = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    
    // 날짜 셀에 표시하기 위한 오늘 날짜
    var today: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    var body: some View {
        VStack {
            headerView()
            calendarGridView()
            Spacer()
        }
        .sheet(isPresented: $showDatePicker) {
            datePickerSheetView()
        }
    }
    
    func headerView() -> some View {
        VStack(spacing: 20) {
            HStack {
                HStack {
                    // 저번 달 이동 버튼
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image.leftTriangle
                            .foregroundColor(canMoveToPreviousMonth() ? Color(.appPrimary) : Color(.appSecondary))
                    }
                    .disabled(!canMoveToPreviousMonth())
                    
                    // 선택된 연월 표시 + 데이트 피커 띄워주는 버튼
                    Button {
                        setYearAndMonth()
                        showDatePicker.toggle()
                    } label: {
                        Text(currentDate.toString("yyyy.MM"))
                            .font(.title2)
                            .bold()
                    }
                    .foregroundStyle(Color(.appPrimary))
                    
                    // 다음 달 이동 버튼
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image.rightTriangle
                            .foregroundColor(canMoveToNextMonth() ? Color(.appPrimary) : Color(.appSecondary))
                    }
                    .disabled(!canMoveToNextMonth())
                }
                Spacer()
                // 오늘로 이동하는 버튼
                Button {
                    currentDate = Date()
                } label: {
                    Image.refresh
                        .bold()
                        .foregroundStyle(Color(.appPrimary))
                }
            }
            .padding(.horizontal)
            
            // 요일 표시
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol.uppercased())
                        .foregroundColor(Color(.appSecondary))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    func datePickerSheetView() -> some View {
        VStack {
            Spacer()
            HStack {
                // 연도 선택기
                // TODO: - 자동으로 연도에 formatting이 들어가는 문제
                Picker("연도", selection: $selectedYear) {
                    ForEach(2020...2050, id: \.self) { year in
                        Text("\(year)년")
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                
                // 월 선택기
                Picker("월", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)월")
                            .tag(month)
                    }
                }
                .pickerStyle(.wheel)
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color(.background))
                    .background(Color(.button))
                    .clipShape(.capsule)
            }
            .padding(.horizontal)
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    func calendarGridView() -> some View {
        let daysInCurrentMonth = numberOfDaysInMonth(in: currentDate)
        let firstWeekday = firstWeekdayOfMonth(in: currentDate)
        let lastDayOfMonthBefore = numberOfDaysInMonth(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInCurrentMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInCurrentMonth + firstWeekday)
        let columns = [GridItem](repeating: GridItem(), count: 7)
        
        return LazyVGrid(columns: columns) {
            ForEach(-firstWeekday..<daysInCurrentMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if 0 <= index && index < daysInCurrentMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = clickedDate == date
                        let isToday = date.isEqual(today)
                        DayCell(day: day, clicked: clicked, isToday: isToday)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        DayCell(day: day, isCurrentMonthDay: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInCurrentMonth {
                        clickedDate = getDate(for: index)
                    }
                }
            }
        }
    }
    
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: currentDate),
            month: calendar.component(.month, from: currentDate),
            day: 1
        )) else { return Date() }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        return calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDaysInMonth(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 해당 월의 첫 날짜가 갖는 요일을 Int 값으로 리턴 (일요일(1)~토요일(7) 인덱스로 쓰기 위해 -1 처리)
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    /// 이전 월의 첫번째 날짜
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        print(previousMonth.formatted())
        return previousMonth
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        self.currentDate = adjustedMonth(by: value)
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
        return Calendar.current.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
    }
    
    // 데이트 피커 초기값 세팅
    func setYearAndMonth() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        selectedYear = components.year ?? 2024
        selectedMonth = components.month ?? 1
    }
    
    // 데이트 피커로 지정한 날짜로 이동하는 함수
    func moveToDatePickerDate() {
        currentDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

// 날짜 셀이 가져야하는 상태
// isCurrentMonth
// isToday
// isClicked
// planCount

// 1. Date 기준
// 이번달 / 저번달 / 다음달
// 투데이인지
// 2. 일정 기준
// 0개 / 1개 / 여러개
struct DayCell: View {
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
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .overlay(Text(String(day)))
            .foregroundColor(textColor)
    }
}

#Preview {
    CalendarView()
}
