//
//  TimeLineView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct TimeLineView: View {
    
    @StateObject private var diaryManager = DiaryManager()
    
    private var diaryDict: [String: [Diary]] {
        return diaryManager.timeLineDiaryDict()
    }
    
    var body: some View {
        ZStack {
            if diaryDict.isEmpty {
                Text("저장된 기록이 없습니다.")
                    .asTextModifier(font: .bold20, color: .appPrimary)
            } else {
                listView()
            }
            AddDiaryButton()
        }
    }
    
    private func listView() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(diaryDict.sorted(by: { $0.key > $1.key }), id: \.key) { (month, diaries) in
                    VStack {
                        // 월 표시
                        Text(month)
                            .asTextModifier(font: .bold20, color: .darkTheme)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        
                        // 해당 월의 다이어리 항목들 표시
                        ForEach(diaries, id: \.id) { diary in
                            DiaryCell(diary: diary)
                        }
                    }
                }
            }
        }
    }
}
