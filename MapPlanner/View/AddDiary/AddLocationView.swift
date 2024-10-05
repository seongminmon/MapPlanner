//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    // TODO: - 페이지네이션
    // TODO: - API 통신 중 progressView 띄우기
    // TODO: - 통신 실패 시 예외 처리
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var recentQuery = ""
    @State private var query = ""
    @State private var response: LocalResponse?
    @State private var locationList: [Location] = []
    
    @Binding var selectedLocation: Location?
    
    var body: some View {
        VStack {
            SearchBar(query: $query, placeholder: "장소를 검색해보세요")
            if locationList.isEmpty {
                SearchEmptyView()
            } else {
                ScrollView {
                    VStack {
                        ForEach(locationList, id: \.id) { item in
                            locationCell(item)
                        }
                    }
                }
                // 키보드 내리기
                .asHideKeyboardModifier()
            }
        }
        // 네비게이션 바
        .navigationTitle("장소 검색")
        .asBasicNavigationBar()
        .onSubmit {
            guard !query.isEmpty && query != recentQuery else { return }
            recentQuery = query
            Task {
                do {
                    let result = try await NetworkManager.shared.callRequest(query)
                    locationList = result.documents.map { $0.toLocation() }
                    response = result
                    print("지역 검색 통신 성공")
                } catch {
                    print("에러 발생: \(error)")
                }
            }
        }
    }
    
    private func locationCell(_ location: Location) -> some View {
        Button {
            selectedLocation = location
            dismiss()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(location.placeName)
                        .asTextModifier(font: .bold15, color: .appPrimary)
                    Text(CategoryName(rawValue: location.category) == nil ? "기타" : location.category)
                        .asTextModifier(font: .regular14, color: .lightSecondary)
                }
                Text(location.addressName)
                    .asTextModifier(font: .regular12, color: .appSecondary)
                Rectangle()
                    .fill(.appSecondary)
                    .frame(height: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
    }
}
