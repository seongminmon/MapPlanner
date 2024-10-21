//
//  ToastView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/30/24.
//

import SwiftUI

struct ToastView: View {
    var type: ToastStyle
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                type.iconImage
                    .foregroundColor(type.themeColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .asTextModifier(font: .bold14, color: .appPrimary)
                }
                
                Spacer(minLength: 10)
                
            }
            .padding()
        }
        .background(.appBackground)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                        .zIndex(1)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder
    func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(type: toast.type, title: toast.title)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}
