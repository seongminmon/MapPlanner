//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var query = ""
    @State private var response: LocalResponse?
    @State private var locationList: [Location] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(locationList, id: \.id) { item in
                    Text(item.placeName)
                }
            }
        }
        // 네비게이션 바
        .navigationTitle("장소 검색")
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
        .searchable(text: $query, prompt: "장소를 검색해보세요")
        .onSubmit(of: .search) {
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
}
