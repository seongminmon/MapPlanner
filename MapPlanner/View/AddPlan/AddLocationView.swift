//
//  AddLocationView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import SwiftUI

struct AddLocationView: View {
    // TODO: - 장소 검색 구현
    // TODO: - 장소 검색 api 구현
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("AddLocationView")
        }
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
    }
}

#Preview {
    AddLocationView()
}
