//
//  TimeLineView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct TimeLineView: View {
    
    @StateObject private var diaryManager = DiaryManager()
    
    var sortedDiaryList: [Diary] {
        return diaryManager.diaryList.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(sortedDiaryList, id: \.id) { item in
                        VStack {
                            Text(item.date.toString(DateFormat.untilDay))
                                .font(.bold18)
                            DiaryCell(diary: item)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            AddDiaryButton()
        }
    }
}
