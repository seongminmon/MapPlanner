//
//  HorizonCalendarView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import HorizonCalendar

struct HorizonCalendarView: UIViewRepresentable {
    
    // TODO: - 일정 있는 날짜는 숫자 대신 다르게 표시하기
    // TODO: - 일정 없는 날짜는 일정 추가하기
    // TODO: - 일정 CRUD
    
    private let content: CalendarViewContent
    
    init() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2050, month: 12, day: 31))!
        
        let content = CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions())
        )
            .dayItemProvider { day in
                Text("\(day.day)")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.secondary))
                    .calendarItemModel
            }
            .monthHeaderItemProvider { value in
                HStack {
                    Button {
                        print("left 탭")
                        // TODO: - 전 달로 이동
                    } label: {
                        Image.leftTriangle
                    }
                    
                    Button {
                        print("달력 탭")
                        // TODO: - Datepicker 띄우기
                    } label: {
                        Text(value.description)
                            .font(.title3)
                            .bold()
                    }
                    
                    Button {
                        print("right 탭")
                        // TODO: - 다음 달로 이동
                    } label: {
                        Image.rightTriangle
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(.primary))
                .calendarItemModel
            }
        
        self.content = content
    }
    
    func makeUIView(context: Context) -> HorizonCalendar.CalendarView {
        return CalendarView(initialContent: content)
    }
    
    func updateUIView(_ uiView: HorizonCalendar.CalendarView, context: Context) {}
}
