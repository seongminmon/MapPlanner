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
    @State private var clickedDate: Date?
    
    // 데이트 피커 관련
    @State private var showDatePicker = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    
    private let calendar = Calendar.current
    
    @ObservedResults(Plan.self) var plans
     
    @State var showPlanListView = false
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                calendarGridView()
                Spacer()
            }
            AddPlanButton(date: clickedDate ?? Date())
        }
        .sheet(isPresented: $showDatePicker) {
            datePickerSheetView()
        }
        .padding(.horizontal)
    }
    
    // MARK: - View Components
    
    private func headerView() -> some View {
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
                        .font(.bold20)
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
    
    private func changeMonthButton(direction: Int, canMove: Bool, image: Image) -> some View {
        Button {
            changeMonth(by: direction)
        } label: {
            image
                .foregroundColor(canMove ? Color(.appPrimary) : Color(.appSecondary))
        }
        .disabled(!canMove)
    }
    
    private func weekView() -> some View {
        HStack {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol.uppercased())
                    .foregroundColor(Color(.appSecondary))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func datePickerSheetView() -> some View {
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
                    .font(.bold15)
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
    
    private func calendarGridView() -> some View {
        // 이번달의 첫요일(== 표시할 저번달 날짜 갯수)
        let firstWeekday = calendar.component(.weekday, from: currentDate) - 1
        // 이번달 날짜수
        let numberOfDaysInCurrentMonth = currentDate.numberOfDaysInMonth()
        // 표시할 열의 수
        let numberOfRows = Int(ceil(Double(firstWeekday + numberOfDaysInCurrentMonth) / 7.0))
        // 표시할 다음달 날짜 갯수
        let numberOfDaysInNextMonth = numberOfRows * 7 - (numberOfDaysInCurrentMonth + firstWeekday)
        
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 7)) {
            ForEach(-firstWeekday..<numberOfDaysInCurrentMonth + numberOfDaysInNextMonth, id: \.self) { index in
                let date = getDate(for: index)
                dayCell(date)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            clickedDate = getDate(for: index)
                        }
                    )
            }
        }
    }
    
    @ViewBuilder
    private func dayCell(_ date: Date) -> some View {
        let clicked = date == clickedDate
        let isCurrentMonth = date.compareYearMonth(currentDate)
        let isToday = date.compareYearMonthDay(Date())
        let day = calendar.component(.day, from: date)
        
        let filteredPlans = plans.filter { $0.date.compareYearMonthDay(date) }
        
        var textColor: Color {
            if clicked {
                return Color(.background)
            } else if isCurrentMonth {
                return Color(.appPrimary)
            } else {
                return Color(.appSecondary)
            }
        }
        
        var backgroundColor: Color {
            if clicked {
                return Color(.appPrimary)
            } else if isToday {
                return Color(.appSecondary)
            } else {
                return Color(.background)
            }
        }
        
        if let firstItem = filteredPlans.first {
            Button {
                showPlanListView.toggle()
            } label: {
                thumbnailView(firstItem)
                    .overlay(alignment: .topTrailing) {
                        if filteredPlans.count > 1 {
                            let displayCount = filteredPlans.count > 9 ? "9+" : "\(filteredPlans.count)"
                            Circle()
                                .fill(Color(.appPrimary))
                                .overlay {
                                    Text(displayCount)
                                        .font(.regular12)
                                        .foregroundStyle(Color(.background))
                                }
                                .frame(width: 18, height: 18)
                                .padding(4)
                        }
                    }
            }
            .sheet(isPresented: $showPlanListView) {
                PlanListView(date: date)
            }
        } else {
            Circle()
                .fill(backgroundColor)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
        }
    }
    
    @ViewBuilder
    private func thumbnailView(_ item: Plan) -> some View {
        GeometryReader { geometry in
            if item.photo, let image = ImageFileManager.shared.loadImageFile(filename: "\(item.id)") {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image.calendar
                    .foregroundStyle(Color(.appPrimary))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color(.appSecondary))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    // MARK: - Actions
    
    // 인덱스로 date 구하기
    private func getDate(for index: Int) -> Date {
        let startDate = currentDate.getFirstDate()!
        return calendar.date(byAdding: .day, value: index, to: startDate)!
    }
    
    // 달력 이동
    private func changeMonth(by value: Int) {
        currentDate = currentDate.byAddingMonth(value)!
    }
    
    // 이전 월로 이동 가능 여부
    private func canMoveToPreviousMonth() -> Bool {
        return currentDate.byAddingMonth(-1)! >= Date.startDate
    }
    
    // 다음 월로 이동 가능 여부
    private func canMoveToNextMonth() -> Bool {
        return currentDate.byAddingMonth(1)! <= Date.endDate
    }
    
    // 데이트 피커 초기값 세팅
    private func setDatePicker() {
        selectedYear = calendar.component(.year, from: currentDate)
        selectedMonth = calendar.component(.month, from: currentDate)
    }
    
    // 현재 날짜를 데이트 피커로 지정한 날짜로 변경
    private func setCurrentDateToDatePickerDate() {
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        currentDate = calendar.date(from: components) ?? Date()
    }
}
