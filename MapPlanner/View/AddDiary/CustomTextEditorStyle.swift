//
//  CustomTextEditorStyle.swift
//  MapPlanner
//
//  Created by 김성민 on 10/2/24.
//

import SwiftUI

struct CustomTextEditorStyle: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .lineSpacing(10)
                        .padding(20)
                        .padding(.top, 2)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.appSecondary))
                }
            }
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled()
            .foregroundStyle(Color(.appPrimary))
            .background(Color(.lightSecondary))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scrollContentBackground(.hidden)
            .font(.regular14)
            .overlay(alignment: .bottomTrailing) {
                Text("\(text.count) / 200")
                    .font(.regular12)
                    .foregroundColor(Color(.appSecondary))
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .onChange(of: text) { newValue in
                        if newValue.count > 200 {
                            text = String(newValue.prefix(200))
                        }
                    }
            }
    }
}

extension TextEditor {
    func customStyleEditor(placeholder: String, userInput: Binding<String>) -> some View {
        self.modifier(CustomTextEditorStyle(placeholder: placeholder, text: userInput))
    }
}
