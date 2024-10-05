//
//  SearchView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct SearchView: View {
    
    @StateObject private var diaryManager = DiaryManager()
    
    @State private var query = ""
    
    // TODO: - 공백만 있을땐 안보이도록 처리
    // 제목 / 내용 / 장소명 / 주소명으로 검색
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
                // 키보드 내리기
                .asHideKeyboardModifier()
            }
        }
        // 네비게이션 바
        .navigationTitle("기록 검색")
        .asBasicNavigationBar()
    }
}
