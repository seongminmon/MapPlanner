//
//  CalenderView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                calendarGridView()
                Spacer()
            }
            .padding()
            AddDiaryButton(date: viewModel.output.clickedDate ?? Date())
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -100 {
                    viewModel.input.changeMonthButtonTap.send(1)
                } else if value.translation.width > 100 {
                    viewModel.input.changeMonthButtonTap.send(-1)
                }
            }
        )
        .sheet(isPresented: $viewModel.output.showDatePicker) {
            datePickerSheetView()
        }
    }
    
    // MARK: - View Components
    
    private func headerView() -> some View {
        VStack(spacing: 15) {
            HStack {
                // 저번 달 이동 버튼
                changeMonthButton(
                    direction: -1,
                    canMove: viewModel.canMoveMonth(-1),
                    image: Image.leftTriangle
                )
                
                // 선택된 연월 표시 + 데이트 피커 띄워주는 버튼
                Button {
                    viewModel.input.showDatePickerButtonTap.send(())
                } label: {
                    Text(viewModel.output.currentDate.toString(DateFormat.untilMonth))
                        .asTextModifier(font: .bold18, color: .appPrimary)
                }
                .foregroundStyle(.appPrimary)
                
                // 다음 달 이동 버튼
                changeMonthButton(
                    direction: 1,
                    canMove: viewModel.canMoveMonth(1),
                    image: Image.rightTriangle
                )
                
                Spacer()
                
                // 이번 달로 돌아오는 버튼
                if !viewModel.output.currentDate.compareUntilMonth(Date()) {
                    Button {
                        viewModel.input.refreshButtonTap.send(())
                    } label: {
                        Text("오늘")
                            .asTextModifier(font: .bold18, color: .darkTheme)
                            .padding(.trailing, 12)
                    }
                }
            }
            weekView()
        }
    }
    
    private func changeMonthButton(direction: Int, canMove: Bool, image: Image) -> some View {
        Button {
            viewModel.input.changeMonthButtonTap.send(direction)
        } label: {
            image
                .foregroundColor(canMove ? .appPrimary : .appSecondary)
        }
        .disabled(!canMove)
    }
    
    private func weekView() -> some View {
        HStack {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol.uppercased())
                    .asTextModifier(font: .regular14, color: .appSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func datePickerSheetView() -> some View {
        VStack {
            Spacer()
            HStack {
                // 연도 선택기
                Picker("연도", selection: $viewModel.output.selectedYear) {
                    ForEach(2020...2050, id: \.self) { year in
                        Text(String(format: "%d년", year))
                            .asTextModifier(font: .regular18, color: .appPrimary)
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                
                // 월 선택기
                Picker("월", selection: $viewModel.output.selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)월")
                            .asTextModifier(font: .regular18, color: .appPrimary)
                            .tag(month)
                    }
                }
                .pickerStyle(.wheel)
            }
            
            // 이동 버튼
            Button {
                viewModel.input.moveDateButtonTap.send(())
            } label: {
                Text("이동")
                    .asButtonText()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    private func calendarGridView() -> some View {
        // 이번달의 첫요일(== 표시할 저번달 날짜 갯수)
        let firstWeekday = Calendar.current.component(.weekday, from: viewModel.output.currentDate) - 1
        // 이번달 날짜수
        let numberOfDaysInCurrentMonth = viewModel.output.currentDate.numberOfDaysInMonth()
        // 표시할 열의 수
        let numberOfRows = Int(ceil(Double(firstWeekday + numberOfDaysInCurrentMonth) / 7.0))
        // 표시할 다음달 날짜 갯수
        let numberOfDaysInNextMonth = numberOfRows * 7 - (numberOfDaysInCurrentMonth + firstWeekday)
        
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 7)) {
            ForEach(-firstWeekday..<numberOfDaysInCurrentMonth + numberOfDaysInNextMonth, id: \.self) { index in
                let date = viewModel.getDate(for: index)
                let clicked = date == viewModel.output.clickedDate
                let isCurrentMonth = date.compareUntilMonth(viewModel.output.currentDate)
                
                DayCell(
                    date: date,
                    clicked: clicked,
                    isCurrentMonth: isCurrentMonth
                )
                .simultaneousGesture(
                    TapGesture().onEnded {
                        viewModel.input.dayCellTap.send(index)
                    }
                )
            }
        }
    }
}
