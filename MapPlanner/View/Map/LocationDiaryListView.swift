//
//  LocationDiaryListView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/29/24.
//

import SwiftUI
import RealmSwift

struct LocationDiaryListView: View {
    
    var location: Location?
    @StateObject private var diaryManager = DiaryManager()
    
    var filteredDiaryList: [Diary] {
        return diaryManager.locationFilteredDiaryList(location?.id)
    }
    
    var body: some View {
        VStack {
            Text(location?.placeName ?? "장소 정보 없음")
                .asTextModifier(font: .bold18, color: .appPrimary)
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
