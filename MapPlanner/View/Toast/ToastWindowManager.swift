//
//  ToastWindowManager.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

// MARK: - 최상단에 토스트 메시지 띄우기
final class ToastWindowManager {
    static let shared = ToastWindowManager()
    private init() {}
    
    func showToast(toast: Binding<Toast?>) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let hostingController = UIHostingController(rootView: EmptyView().toastView(toast: toast))
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = window.bounds
        hostingController.view.isUserInteractionEnabled = false
        
        window.addSubview(hostingController.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, animations: {
                hostingController.view.alpha = 0
            }) { _ in
                hostingController.view.removeFromSuperview()
            }
        }
    }
}
