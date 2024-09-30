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
    
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
