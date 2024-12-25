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
// TODO: - Push Notification 추가
// TODO: - 테스트 코드 작성

@main
struct MapPlannerApp: App {
    
    @State private var toast: Toast? = nil
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    // Toast NotificationCenter 구독
                    NotificationCenter.default.addObserver(
                        forName: .showToast,
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let userInfo = notification.toast {
                            self.toast = toast
                            ToastWindowManager.shared.showToast(toast: self.$toast)
                        }
                    }
                }
        }
    }
}
