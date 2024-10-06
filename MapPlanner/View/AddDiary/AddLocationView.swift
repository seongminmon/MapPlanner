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
    @StateObject private var viewModel = AddLocationViewModel()
    
    var body: some View {
        VStack {
            SearchBar(query: $viewModel.output.query, placeholder: "장소를 검색해보세요")
            if viewModel.output.locationList.isEmpty {
                SearchEmptyView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.output.locationList, id: \.id) { item in
                            locationCell(item)
                                .onAppear {
                                    viewModel.input.onAppearItem.send(item)
                                }
                        }
                    }
                }
                .asHideKeyboardModifier()
            }
        }
        .overlay(
            Group {
                if viewModel.output.isLoading {
                    LoadingView()
                }
            }
        )
        // 네비게이션 바
        .navigationTitle("장소 검색")
        .asBasicNavigationBar()
        .onSubmit {
            viewModel.input.searchButtonTap.send(())
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
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
    }
}
