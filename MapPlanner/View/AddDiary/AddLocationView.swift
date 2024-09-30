//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    // TODO: - 페이지네이션
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) private var dismissSearch
    
    @State private var query = ""
    @State private var response: LocalResponse?
    @State private var locationList: [Location] = []
    
    @Binding var selectedLocation: Location?
    
    var body: some View {
        VStack {
            SearchBar(query: $query, placeholder: "장소를 검색해보세요")
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(locationList, id: \.id) { item in
                        locationCell(item)
                    }
                }
            }
        }
        // 네비게이션 바
        .navigationTitle("장소 검색")
        .navigationBarTitleDisplayMode(.inline)
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
        .scrollDismissesKeyboard(.immediately)
        .onSubmit {
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
            dismissSearch()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(location.placeName)
                    .font(.bold15)
                    .foregroundStyle(Color(.appPrimary))
                Text(location.addressName)
                    .font(.regular12)
                    .foregroundStyle(Color(.appSecondary))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}
