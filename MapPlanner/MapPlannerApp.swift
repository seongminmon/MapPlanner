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
            RootView()
                .onAppear {
                    debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
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
