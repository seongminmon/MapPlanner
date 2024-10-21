//
//  HideKeyboardModifier.swift
//  MapPlanner
//
//  Created by 김성민 on 10/21/24.
//

import SwiftUI

struct HideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appBackground)
            .onTapGesture { content.hideKeyboard() }
            .scrollDismissesKeyboard(.immediately)
    }
}
