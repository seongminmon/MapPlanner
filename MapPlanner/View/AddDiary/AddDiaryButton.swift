//
//  AddDiaryButton.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct AddDiaryButton: View {
    
    var date = Date()
    
    var body: some View {
        NavigationLink {
            EditDiaryView(diary: nil, selectedDate: date)
        } label: {
            Image.plus
                .resizable()
                .frame(width: 20, height: 20)
                .frame(width: 50, height: 50)
                .foregroundStyle(.white)
                .background(.darkTheme)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
    }
}
