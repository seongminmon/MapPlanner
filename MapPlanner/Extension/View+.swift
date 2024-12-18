//
//  View+.swift
//  MapPlanner
//
//  Created by 김성민 on 9/21/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Custom Modifier
extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
    
    func asTextModifier(font: Font, color: Color) -> some View {
        modifier(TextModifier(font: font, color: color))
    }
    
    func asButtonText() -> some View {
        modifier(ButtonText())
    }
    
    func asRootNavigationBar() -> some View {
        modifier(RootNavigationBar())
    }
    
    func asBasicNavigationBar() -> some View {
        modifier(BasicNavigationBar())
    }
    
    func asHideKeyboardModifier() -> some View {
        modifier(HideKeyboardModifier())
    }
}
