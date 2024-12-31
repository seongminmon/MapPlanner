//
//  TextModifier.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

struct TextModifier: ViewModifier {
    
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
    }
}
