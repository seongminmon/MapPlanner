//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    // TODO: - Location 수정 안 되는 문제 (Realm + 뷰 둘다)
    // TODO: - 페이지네이션
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var query = ""
    @State private var response: LocalResponse?
    @State private var locationList: [Location] = []
    
    @Binding var selectedLocation: Location?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(locationList, id: \.id) { item in
                    locationCell(item)
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
    
    private func locationCell(_ location: Location) -> some View {
        Button {
            selectedLocation = location
            dismiss()
        } label: {
            VStack(alignment: .leading) {
                Text(location.placeName)
                    .font(.bold15)
                Text(location.addressName)
                    .font(.regular14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 100)
            .background(Color(.lightTheme))
            .padding()
        }
    }
}
