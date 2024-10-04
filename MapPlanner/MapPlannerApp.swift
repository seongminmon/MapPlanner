//
//  MapPlannerApp.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI
import RealmSwift

@main
struct MapPlannerApp: App {
    
    @State private var toast: Toast? = nil {
        didSet {
            print("toast Did Set", toast ?? "토스트 없음")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
            }
            .onAppear {
                print("루트뷰 onAppear")
                debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
                // NotificationCenter 구독
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("ShowToast"),
                    object: nil,
                    queue: .main
                ) { notification in
                    if let userInfo = notification.userInfo, let toast = userInfo["toast"] as? Toast {
                        self.toast = toast
                        ToastWindowManager.shared.showToast(toast: self.$toast)
                    }
                }
            }
        }
    }
}

class ToastWindowManager {
    static let shared = ToastWindowManager()
    private init() {}
    
    func showToast(toast: Binding<Toast?>) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let hostingController = UIHostingController(rootView: EmptyView().toastView(toast: toast))
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = window.bounds
        
        // Disable user interaction on the toast view
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
