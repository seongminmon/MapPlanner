//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedLocation: Location?
    
    @State private var response: LocalResponse?
    @State private var locationList: [Location] = [] {
        didSet {
            print("검색 갯수", locationList.count)
        }
    }
    
    @State private var recentQuery = ""
    @State private var query = ""
    
    @State private var page = 1
    @State private var isEnd = false
    
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            SearchBar(query: $query, placeholder: "장소를 검색해보세요")
            if locationList.isEmpty {
                SearchEmptyView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(locationList, id: \.id) { item in
                            locationCell(item)
                                .onAppear {
                                    if locationList.last == item {
                                        pagination()
                                    }
                                }
                        }
                    }
                }
                // 키보드 내리기
                .asHideKeyboardModifier()
            }
        }
        .overlay(
            Group {
                if isLoading {
                    LoadingView() // 로딩 중일 때 로딩 뷰 표시
                }
            }
        )
        // 네비게이션 바
        .navigationTitle("장소 검색")
        .asBasicNavigationBar()
        .onSubmit {
            search()
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
    
    private func search() {
        // 검색 시 새로운 통신
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                query != recentQuery else { return }
        
        recentQuery = query
        page = 1
        isEnd = false
        response = nil
        locationList.removeAll()
        
        isLoading = true
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(query, page: page)
                locationList = result.documents.map { $0.toLocation() }
                response = result
                print("지역 검색 성공")
                
                // 로딩 종료를 최소 0.5초 후에 진행
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isLoading = false
                }
            } catch {
                print("지역 검색 에러 발생: \(error)")
                isLoading = false
            }
        }

    }
    
    private func pagination() {
        if isEnd {
            print("마지막 페이지")
            return
        }
        
        page += 1
        isLoading = true
        
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(recentQuery, page: page)
                let newLocationList = result.documents.map { $0.toLocation() }
                locationList.append(contentsOf: newLocationList)
                response = result
                isEnd = result.meta.is_end
                print("페이지네이션 통신 성공")
                
                // 로딩 종료를 최소 0.5초 후에 진행
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isLoading = false
                }
            } catch {
                print("페이지네이션 에러 발생: \(error)")
                isLoading = false
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
            .frame(width: 100, height: 100)
            .tint(.appSecondary)
            .background(.appSecondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
