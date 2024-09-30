//
//  DayCell.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

import SwiftUI

struct DayCell: View {
    
    var date: Date
    var clicked: Bool
    var isCurrentMonth: Bool
    
    @StateObject private var diaryManager = DiaryManager()
    
    var filteredDiaryList: [Diary] {
        return diaryManager.dateFilteredDiaryList(date)
    }
    
    @State private var showDiaryListView = false
    
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
            return Color(.lightSecondary)
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
        if let firstItem = filteredDiaryList.first {
            Button {
                showDiaryListView.toggle()
            } label: {
                thumbnailView(firstItem)
                    .overlay(alignment: .topTrailing) {
                        if filteredDiaryList.count > 1 {
                            let displayCount = filteredDiaryList.count > 9 ? "9+" : "\(filteredDiaryList.count)"
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
            .sheet(isPresented: $showDiaryListView) {
                DateDiaryListView(date: date)
            }
        } else {
            Circle()
                .fill(backgroundColor)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
        }
    }
    
    @ViewBuilder
    private func thumbnailView(_ item: Diary) -> some View {
        GeometryReader { geometry in
            if let image = ImageFileManager.shared.loadImageFile(filename: item.id) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
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
