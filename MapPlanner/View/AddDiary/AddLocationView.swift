//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    // TODO: - 페이지네이션
    // TODO: - 디자인 변경
    
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
                VStack(spacing: 10) {
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
            VStack(alignment: .leading) {
                Text(location.placeName)
                    .font(.bold18)
                    .foregroundStyle(Color(.appPrimary))
                Text(location.addressName)
                    .font(.regular15)
                    .foregroundStyle(Color(.appSecondary))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}
