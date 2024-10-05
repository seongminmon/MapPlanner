//
//  ButtonText.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

struct ButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .asTextModifier(font: .bold15, color: .appBackground)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.darkTheme)
            .clipShape(.capsule)
            .padding()
    }
}
