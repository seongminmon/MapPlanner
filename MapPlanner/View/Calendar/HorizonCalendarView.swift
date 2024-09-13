//
//  HorizonCalendarView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import HorizonCalendar

struct HorizonCalendarView: UIViewRepresentable {
    
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
                    .foregroundColor(.secondary)
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
                .foregroundStyle(.primary)
                .calendarItemModel
            }
        
        self.content = content
    }
    
    func makeUIView(context: Context) -> HorizonCalendar.CalendarView {
        return CalendarView(initialContent: content)
    }
    
    func updateUIView(_ uiView: HorizonCalendar.CalendarView, context: Context) {}
}
