//
//  SearchView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct SearchView: View {
 
    @Environment(\.dismiss) private var dismiss
    
    @State private var text = ""
    @State private var query = ""
    @ObservedResults(Plan.self) var plans
    
    // 제목 / 내용 / 장소명 / 주소명으로 검색
    var filteredPlans: [Plan] {
        return plans.filter {
            $0.title.contains(query) ||
            $0.contents.contains(query) ||
            $0.placeName.contains(query) ||
            $0.addressName.contains(query)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(filteredPlans, id: \.id) { item in
                    PlanCell(plan: item)
                }
            }
        }
        // 네비게이션 바
        .navigationTitle("일정 검색")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.leftChevron
                }
                .foregroundStyle(Color(.appPrimary))
            }
        }
        // 키보드 내리기
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
        .searchable(text: $text, prompt: "일정을 검색해보세요")
        .onSubmit(of: .search) {
            query = text
        }
    }
}
