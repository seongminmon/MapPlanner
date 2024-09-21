//
//  CalenderView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct CalendarView: View {
    
    // 달력 표시되고 있는 달 (연/월까지 유효)
    @State private var currentDate = Date().getFirstDate()!
    // 유저가 선택한 날짜 (연/월/일까지 유효)
    @State private var clickedDate: Date? {
        didSet {
            print(clickedDate)
        }
    }
    
    // 데이트 피커 관련
    @State private var showDatePicker = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    
    private let calendar = Calendar.current
    
    // Realm에 저장된 일정 데이터
    @ObservedResults(Plan.self) var plans
    
    var body: some View {
        VStack {
            headerView()
            calendarGridView()
            Spacer()
        }
        .sheet(isPresented: $showDatePicker) {
            datePickerSheetView()
        }
        .padding(.horizontal)
    }
    
    func headerView() -> some View {
        VStack(spacing: 20) {
            HStack {
                // 저번 달 이동 버튼
                changeMonthButton(
                    direction: -1,
                    canMove: canMoveToPreviousMonth(),
                    image: Image.leftTriangle
                )
                
                // 선택된 연월 표시 + 데이트 피커 띄워주는 버튼
                Button {
                    setDatePicker()
                    showDatePicker.toggle()
                } label: {
                    Text(currentDate.toString("yyyy.MM"))
                        .font(.title2)
                        .bold()
                }
                .foregroundStyle(Color(.appPrimary))
                
                // 다음 달 이동 버튼
                changeMonthButton(
                    direction: 1,
                    canMove: canMoveToNextMonth(),
                    image: Image.rightTriangle
                )
                
                Spacer()
                
                // 이번 달로 돌아오는 버튼
                if !currentDate.compareYearMonth(Date()) {
                    Button {
                        currentDate = Date()
                    } label: {
                        Image.refresh
                            .bold()
                            .foregroundStyle(Color(.appPrimary))
                    }
                }
            }
            
            // 요일 표시
            weekView()
        }
    }
    
    func changeMonthButton(direction: Int, canMove: Bool, image: Image) -> some View {
        Button {
            changeMonth(by: direction)
        } label: {
            image
                .foregroundColor(canMove ? Color(.appPrimary) : Color(.appSecondary))
        }
        .disabled(!canMove)
    }
    
    func weekView() -> some View {
        HStack {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol.uppercased())
                    .foregroundColor(Color(.appSecondary))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func datePickerSheetView() -> some View {
        VStack {
            Spacer()
            HStack {
                // TODO: - Picker 디자인 변경
                // TODO: - 자동으로 연도에 formatting이 들어가는 문제
                // 연도 선택기
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
            
            // 이동 버튼
            Button {
                setCurrentDateToDatePickerDate()
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
                    .padding()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    func calendarGridView() -> some View {
        // 이번달의 첫요일(== 표시할 저번달 날짜 갯수)
        let firstWeekday: Int = {
            // 해당 월의 첫 날짜가 갖는 요일을 Int 값으로 리턴: 일요일(1)~토요일(7)
            // 인덱스로 쓰기 위해 -1 처리
            return calendar.component(.weekday, from: currentDate) - 1
        }()
        
        // 이번달 날짜수
        let numberOfDaysInCurrentMonth = currentDate.numberOfDaysInMonth()
        // 표시할 열의 수
        let numberOfRows = Int(ceil(Double(firstWeekday + numberOfDaysInCurrentMonth) / 7.0))
        // 표시할 다음달 날짜 갯수
        let numberOfDaysInNextMonth = numberOfRows * 7 - (numberOfDaysInCurrentMonth + firstWeekday)
        
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 7)) {
            ForEach(-firstWeekday..<numberOfDaysInCurrentMonth + numberOfDaysInNextMonth, id: \.self) { index in
                let date = getDate(for: index)
                let day = calendar.component(.day, from: date)
                let clicked = clickedDate == date
                let isToday = date.compareYearMonthDay(Date())
                let isCurrentMonth = date.compareYearMonth(currentDate)
                
                // TODO: - plan 적용하기
                let temp = Array(plans.filter { plan in
                    plan.date.compareYearMonthDay(date)
                })
                DayCell(
                    day: day,
                    clicked: clicked,
                    isToday: isToday,
                    isCurrentMonth: isCurrentMonth,
                    plans: temp
                )
                .onTapGesture {
                    clickedDate = getDate(for: index)
                }
            }
        }
    }
    
    /// 인덱스로 date 구하기
    func getDate(for index: Int) -> Date {
        let startDate = currentDate.getFirstDate()!
        return calendar.date(byAdding: .day, value: index, to: startDate)!
    }
    
    /// 달력 이동
    func changeMonth(by value: Int) {
        currentDate = currentDate.byAddingMonth(value)!
    }
    
    /// 이전 월로 이동 가능 여부
    func canMoveToPreviousMonth() -> Bool {
        return currentDate.byAddingMonth(-1)! >= Date.startDate
    }
    
    /// 다음 월로 이동 가능 여부
    func canMoveToNextMonth() -> Bool {
        return currentDate.byAddingMonth(1)! <= Date.endDate
    }
    
    /// 데이트 피커 초기값 세팅
    func setDatePicker() {
        selectedYear = calendar.component(.year, from: currentDate)
        selectedMonth = calendar.component(.month, from: currentDate)
    }
    
    /// 현재 날짜를 데이트 피커로 지정한 날짜로 변경
    func setCurrentDateToDatePickerDate() {
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        currentDate = calendar.date(from: components) ?? Date()
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
    var day: Int
    var clicked: Bool
    var isToday: Bool
    var isCurrentMonth: Bool
    var plans = [Plan]()
    
    @State private var showPlansSheetView = false
    
    private var textColor: Color {
        if clicked {
            return Color(.background)
        } else if isCurrentMonth {
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
    
    var body: some View {
        if plans.isEmpty {
            Circle()
                .fill(backgroundColor)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
        } else {
            Button {
                showPlansSheetView.toggle()
            } label: {
                Text("일정 \(plans.count)")
            }
            .sheet(isPresented: $showPlansSheetView) {
                plansSheetView()
            }
        }
    }
    
    func plansSheetView() -> some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(plans, id: \.id) { item in
                    planCell(item)
                }
            }
            .padding()
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    func planCell(_ item: Plan) -> some View {
        HStack(alignment: .top) {
            if item.photo, let image = ImageFileManager.shared.loadImageFile(filename: "\(item.id)") {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color(.appPrimary))
                Text(item.contents ?? "")
                    .foregroundStyle(Color(.appSecondary))
                    .lineLimit(2)
            }
            Spacer()
        }
    }
}

#Preview {
    CalendarView()
}
