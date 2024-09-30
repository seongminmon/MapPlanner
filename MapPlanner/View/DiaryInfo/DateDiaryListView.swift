//
//  DateDiaryListView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import RealmSwift

struct DateDiaryListView: View {
    
    var date: Date
    @StateObject private var diaryManager = DiaryManager()
    
    var filteredDiaryList: [Diary] {
        return diaryManager.dateFilteredDiaryList(date)
    }
    
    var body: some View {
        VStack {
            Text(date.toString(DateFormat.untilDay))
                .font(.bold18)
                .padding(.top, 10)
            ScrollView {
                VStack {
                    ForEach(filteredDiaryList, id: \.id) { item in
                        DiaryCell(diary: item)
                    }
                }
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
}
