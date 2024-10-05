//
//  NavigationBar.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

struct RootNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Map Diary")
                        .asTextModifier(font: .boldTitle, color: .darkTheme)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image.search
                    }
                    .foregroundStyle(.appPrimary)
                }
            }
    }
}

struct BasicNavigationBar: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.leftChevron
                    }
                    .foregroundStyle(.appPrimary)
                }
            }
    }
}

struct HideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appBackground)
            .onTapGesture { content.hideKeyboard() }
            .scrollDismissesKeyboard(.immediately)
    }
}
