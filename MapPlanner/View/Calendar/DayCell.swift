//
//  DayCell.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

import SwiftUI
import RealmSwift

struct DayCell: View {
    
    var date: Date
    var clicked: Bool
    var isCurrentMonth: Bool
    
    @State private var showPlanListView = false
    @ObservedResults(Plan.self) var plans
    
    var filteredPlans: [Plan] {
        return plans.filter { $0.date.compareYearMonthDay(date) }
    }
    
    var isToday: Bool {
        return date.compareYearMonthDay(Date())
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: date)
    }
    
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
    
    var body: some View {
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
                let _ = print(date)
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
}