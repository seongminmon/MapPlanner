//
//  SearchBar.swift
//  MapPlanner
//
//  Created by 김성민 on 9/30/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var query: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $query)
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled(true)
            .overlay(alignment: .trailing) {
                Button {
                    query = ""
                    hideKeyboard()
                } label: {
                    Image.xmarkFill
                        .padding()
                        .offset(x: 10)
                }
                .foregroundStyle(Color(.appSecondary))
                .opacity(query.isEmpty ? 0 : 1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
    }
}
