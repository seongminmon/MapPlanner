//
//  DiarySearchView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct DiarySearchView: View {
    
    @StateObject private var diaryManager = DiaryManager()
    
    @State private var query = ""
    
    // 제목 / 내용 / 장소명 / 주소명 / 카테고리로 검색
    private var filteredDiaryList: [Diary] {
        diaryManager.searchedDiaryList(query)
    }
    
    var body: some View {
        VStack {
            SearchBar(query: $query, placeholder: "기록을 검색해보세요")
            if filteredDiaryList.isEmpty {
                SearchEmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredDiaryList, id: \.id) { item in
                            DiaryCell(diary: item)
                        }
                    }
                }
                .asHideKeyboardModifier()
            }
        }
        // 네비게이션 바
        .navigationTitle("기록 검색")
        .asBasicNavigationBar()
    }
}
