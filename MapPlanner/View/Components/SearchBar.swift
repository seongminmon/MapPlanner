//
//  SearchBar.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    var placeholder: LocalizedStringKey
 
    var body: some View {
        HStack {
            HStack {
                Image.search
                TextField(placeholder, text: $text)
                    .foregroundColor(Color(.appPrimary))
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image.xmarkFill
                    }
                }
            }
            .padding(8)
            .foregroundColor(Color(.appSecondary))
            .background(Color(.background))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.appSecondary), lineWidth: 1)
            }
        }
        .padding(.horizontal)
    }
}
