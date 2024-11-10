//
//  MapPlannerApp.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI
import RealmSwift

// TODO: - 사진 비율 조절 기능
// TODO: - 다국어 대응
// TODO: - 위젯 추가

@main
struct MapPlannerApp: App {
    
    @State private var toast: Toast? = nil
    
    var body: some Scene {
        WindowGroup {
//            CounterView()
            RootView()
                .onAppear {
                    // NotificationCenter 구독
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name(NotificationName.showToast.rawValue),
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let userInfo = notification.userInfo, let toast = userInfo[NotificationUserInfo.toast.rawValue] as? Toast {
                            self.toast = toast
                            ToastWindowManager.shared.showToast(toast: self.$toast)
                        }
                    }
                }
        }
    }
}
